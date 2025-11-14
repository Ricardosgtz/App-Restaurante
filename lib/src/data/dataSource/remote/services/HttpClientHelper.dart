import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpClientHelper {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration requestTimeout = Duration(seconds: 30);

  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool enableRetry = true,
  }) async {
    return _executeWithRetry(
      method: 'GET',
      url: url,
      headers: headers,
      enableRetry: enableRetry,
      executor: () => http.get(url, headers: headers).timeout(requestTimeout),
    );
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
    bool enableRetry = true,
  }) async {
    return _executeWithRetry(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
      enableRetry: enableRetry,
      executor:
          () => http
              .post(url, headers: headers, body: body)
              .timeout(requestTimeout),
    );
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
    bool enableRetry = true,
  }) async {
    return _executeWithRetry(
      method: 'PUT',
      url: url,
      headers: headers,
      body: body,
      enableRetry: enableRetry,
      executor:
          () => http
              .put(url, headers: headers, body: body)
              .timeout(requestTimeout),
    );
  }

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    bool enableRetry = true,
  }) async {
    return _executeWithRetry(
      method: 'DELETE',
      url: url,
      headers: headers,
      enableRetry: enableRetry,
      executor:
          () => http.delete(url, headers: headers).timeout(requestTimeout),
    );
  }

  static Future<http.Response> _executeWithRetry({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    dynamic body,
    required bool enableRetry,
    required Future<http.Response> Function() executor,
  }) async {
    int attempt = 0;

    while (attempt < (enableRetry ? maxRetries : 1)) {
      attempt++;
      try {
        final response = await executor();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        if (response.statusCode >= 400 && response.statusCode < 500) {
          return response;
        }
        if (response.statusCode >= 500 && attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        return response;
      } on TimeoutException catch (_) {
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        rethrow;
      } on SocketException catch (_) {
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        rethrow;
      } catch (_) {
        rethrow;
      }
    }

    throw Exception(
      'Se agotaron los intentos después de $maxRetries reintentos',
    );
  }

  static Future<http.StreamedResponse> sendMultipart(
    http.MultipartRequest request, {
    bool enableRetry = true,
  }) async {
    int attempt = 0;

    while (attempt < (enableRetry ? maxRetries : 1)) {
      attempt++;
      try {
        final response = await request.send().timeout(requestTimeout);
        if (response.statusCode < 500) {
          return response;
        }
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        return response;
      } on TimeoutException catch (_) {
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        rethrow;
      } on SocketException catch (_) {
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        rethrow;
      }
    }

    throw Exception(
      'Se agotaron los intentos después de $maxRetries reintentos',
    );
  }
}
