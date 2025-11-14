import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/HttpClientHelper.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:http/http.dart' as http;

abstract class BaseService {
  final SharedPref _sharedPref = SharedPref();
  final ResponseCache _cache = ResponseCache();

  Future<String?> getToken() async {
    try {
      final data = await _sharedPref.read('cliente');

      if (data == null) {
        return null;
      }

      if (data is! Map<String, dynamic>) {
        await _sharedPref.remove('cliente');
        return null;
      }

      final authResponse = AuthResponse.fromJson(data);
      final isExpired = TokenHelper.isTokenExpired(authResponse);

      if (!isExpired) {
        return authResponse.token;
      }

      return null;
    } catch (e) {
      await _sharedPref.remove('cliente');
      return null;
    }
  }

  Future<bool> validateToken(BuildContext context) async {
    try {
      final token = await getToken();
      if (token == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return false;
      }
      return true;
    } catch (e) {
      await _sharedPref.remove('cliente');
      if (context.mounted) {
        await AuthExpiredHandler.handleUnauthorized(context);
      }
      return false;
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {"Content-Type": "application/json", "Authorization": token ?? ''};
  }

  Future<String?> validateAndGetToken(BuildContext context) async {
    try {
      final data = await _sharedPref.read('cliente');

      if (data == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return null;
      }

      if (data is! Map<String, dynamic>) {
        await _sharedPref.remove('cliente');
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return null;
      }

      final authResponse = AuthResponse.fromJson(data);

      if (!TokenHelper.isTokenExpired(authResponse)) {
        return authResponse.token;
      }

      if (context.mounted) {
        await AuthExpiredHandler.handleUnauthorized(context);
      }
      return null;
    } catch (e) {
      await _sharedPref.remove('cliente');
      if (context.mounted) {
        await AuthExpiredHandler.handleUnauthorized(context);
      }
      return null;
    }
  }

  Future<Resource<T>> getCached<T>({
    required String url,
    required BuildContext context,
    required T Function(dynamic data) onSuccess,
    Duration? cacheDuration,
    bool useCache = true,
    bool enableRetry = true,
  }) async {
    try {
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) {
        _cache.clear();
        return Error("Sesión expirada");
      }

      final cacheKey = ResponseCache.generateKey(url);

      if (useCache) {
        final cachedData = _cache.get(cacheKey);
        if (cachedData != null) {
          return Success(onSuccess(cachedData));
        }
      }

      final headers = await getAuthHeaders();
      final uri = Uri.parse(url);
      final response = await HttpClientHelper.get(
        uri,
        headers: headers,
        enableRetry: enableRetry,
      );

      final result = await handleResponse<T>(
        response: response,
        context: context,
        onSuccess: onSuccess,
      );

      if (result is Success && useCache) {
        final data = json.decode(response.body);
        _cache.set(
          cacheKey,
          data,
          duration: cacheDuration ?? CacheDuration.medium,
        );
      }

      return result;
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<T>> handleResponse<T>({
    required http.Response response,
    required BuildContext context,
    required T Function(dynamic data) onSuccess,
  }) async {
    try {
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(onSuccess(data));
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else if (response.statusCode == 403) {
        return Error("No tienes permisos para realizar esta acción");
      } else if (response.statusCode == 404) {
        return Error("Recurso no encontrado");
      } else if (response.statusCode >= 500) {
        return Error("Error del servidor. Intenta más tarde.");
      } else {
        return Error(ListToString(data['message'] ?? 'Error desconocido'));
      }
    } catch (e) {
      return Error('Error al procesar la respuesta: $e');
    }
  }

  Future<Resource<T>> handleStreamedResponse<T>({
    required http.StreamedResponse response,
    required BuildContext context,
    required T Function(dynamic data) onSuccess,
  }) async {
    try {
      final responseString =
          await response.stream.transform(utf8.decoder).join();
      final data = json.decode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(onSuccess(data));
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else {
        return Error(ListToString(data['message'] ?? 'Error desconocido'));
      }
    } catch (e) {
      return Error('Error al procesar la respuesta: $e');
    }
  }

  void invalidateCache(String pattern) {
    _cache.removeByPattern(pattern);
  }

  void clearCache() {
    _cache.clear();
  }
}