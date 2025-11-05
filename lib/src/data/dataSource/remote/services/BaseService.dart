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

/// 🎯 Clase base para todos los servicios
/// Centraliza: tokens, validación, manejo de respuestas, caché y retry logic
abstract class BaseService {
  final SharedPref _sharedPref = SharedPref();
  final ResponseCache _cache = ResponseCache();

  /// 🔑 Obtiene el token fresco de SharedPrefs
  Future<String?> getToken() async {
    try {
      final data = await _sharedPref.read('cliente');
      if (data != null) {
        final authResponse = AuthResponse.fromJson(data);
        if (!TokenHelper.isTokenExpired(authResponse)) {
          return authResponse.token;
        }
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo token: $e');
      return null;
    }
  }

  /// 🛡️ Valida el token y maneja el error 401 si es necesario
  Future<bool> validateToken(BuildContext context) async {
    final token = await getToken();
    if (token == null) {
      if (context.mounted) {
        await AuthExpiredHandler.handleUnauthorized(context);
      }
      return false;
    }
    return true;
  }

  /// 📋 Obtiene los headers con el token
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": token ?? '',
    };
  }

  /// 📤 Validación previa antes de hacer cualquier petición
  Future<String?> validateAndGetToken(BuildContext context) async {
    final token = await getToken();
    
    if (token == null) {
      if (context.mounted) {
        await AuthExpiredHandler.handleUnauthorized(context);
      }
    }
    
    return token;
  }

  /// 🔄 GET con caché y retry
  Future<Resource<T>> getCached<T>({
    required String url,
    required BuildContext context,
    required T Function(dynamic data) onSuccess,
    Duration? cacheDuration,
    bool useCache = true,
    bool enableRetry = true,
  }) async {
    try {
      // Validar token
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) return Error("Sesión expirada");

      // Generar cache key
      final cacheKey = ResponseCache.generateKey(url);

      // Intentar obtener de caché
      if (useCache) {
        final cachedData = _cache.get(cacheKey);
        if (cachedData != null) {
          return Success(onSuccess(cachedData));
        }
      }

      // Hacer petición con retry
      final headers = await getAuthHeaders();
      final uri = Uri.parse(url);
      final response = await HttpClientHelper.get(
        uri,
        headers: headers,
        enableRetry: enableRetry,
      );

      // Procesar respuesta
      final result = await handleResponse<T>(
        response: response,
        context: context,
        onSuccess: onSuccess,
      );

      // Guardar en caché si fue exitoso
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
      print('❌ Error en getCached: $e');
      return Error(e.toString());
    }
  }

  /// 🔄 Método genérico para manejar respuestas HTTP
  Future<Resource<T>> handleResponse<T>({
    required http.Response response,
    required BuildContext context,
    required T Function(dynamic data) onSuccess,
  }) async {
    try {
      final data = json.decode(response.body);

      // ✅ Respuesta exitosa
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(onSuccess(data));
      }
      // ⚠️ Token expirado o no autorizado
      else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }
      // 🚫 Forbidden
      else if (response.statusCode == 403) {
        return Error("No tienes permisos para realizar esta acción");
      }
      // ❌ Not Found
      else if (response.statusCode == 404) {
        return Error("Recurso no encontrado");
      }
      // ⚠️ Server Error
      else if (response.statusCode >= 500) {
        return Error("Error del servidor. Intenta más tarde.");
      }
      // ❌ Otros errores
      else {
        return Error(ListToString(data['message'] ?? 'Error desconocido'));
      }
    } catch (e) {
      print('❌ Error procesando respuesta: $e');
      return Error('Error al procesar la respuesta: $e');
    }
  }

  /// 🔄 Método genérico para manejar respuestas de StreamedResponse (multipart)
  Future<Resource<T>> handleStreamedResponse<T>({
    required http.StreamedResponse response,
    required BuildContext context,
    required T Function(dynamic data) onSuccess,
  }) async {
    try {
      final responseString = await response.stream.transform(utf8.decoder).join();
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
      print('❌ Error procesando respuesta: $e');
      return Error('Error al procesar la respuesta: $e');
    }
  }

  /// 🧹 Invalida caché por patrón (útil después de crear/actualizar/eliminar)
  void invalidateCache(String pattern) {
    _cache.removeByPattern(pattern);
  }

  /// 🧹 Limpiar toda la caché del servicio
  void clearCache() {
    _cache.clear();
  }
}