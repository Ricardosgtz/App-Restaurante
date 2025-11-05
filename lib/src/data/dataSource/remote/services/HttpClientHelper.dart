import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// 🔄 Helper para peticiones HTTP con retry logic y logging
class HttpClientHelper {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration requestTimeout = Duration(seconds: 30);

  /// 📊 Interceptor de requests
  static void _logRequest(String method, Uri url, Map<String, String>? headers, dynamic body) {
    print('🌐 ═══════════════════════════════════════════════════════');
    print('📤 REQUEST: $method ${url.path}');
    print('🔗 URL: $url');
    print('🕐 Time: ${DateTime.now().toIso8601String()}');
    
    if (headers != null && headers.isNotEmpty) {
      print('📋 Headers:');
      headers.forEach((key, value) {
        // Ocultar token completo por seguridad
        if (key == 'Authorization') {
          print('   $key: ${value.substring(0, 20)}...');
        } else {
          print('   $key: $value');
        }
      });
    }
    
    if (body != null && body.toString().isNotEmpty) {
      try {
        final bodyStr = body is String ? body : json.encode(body);
        final bodyJson = json.decode(bodyStr);
        print('📦 Body: ${json.encode(bodyJson)}');
      } catch (e) {
        print('📦 Body: $body');
      }
    }
    print('═══════════════════════════════════════════════════════');
  }

  /// 📊 Interceptor de responses
  static void _logResponse(String method, Uri url, http.Response response, Duration duration) {
    final statusEmoji = response.statusCode >= 200 && response.statusCode < 300 
        ? '✅' 
        : response.statusCode >= 400 && response.statusCode < 500 
            ? '⚠️' 
            : '❌';
    
    print('🌐 ═══════════════════════════════════════════════════════');
    print('$statusEmoji RESPONSE: $method ${url.path}');
    print('📊 Status: ${response.statusCode}');
    print('⏱️ Duration: ${duration.inMilliseconds}ms');
    
    try {
      final data = json.decode(response.body);
      print('📦 Body: ${json.encode(data)}');
    } catch (e) {
      print('📦 Body: ${response.body}');
    }
    print('═══════════════════════════════════════════════════════\n');
  }

  /// 📊 Log de error
  static void _logError(String method, Uri url, dynamic error, int attempt) {
    print('🌐 ═══════════════════════════════════════════════════════');
    print('❌ ERROR: $method ${url.path}');
    print('🔢 Attempt: $attempt/$maxRetries');
    print('⚠️ Error: $error');
    print('═══════════════════════════════════════════════════════\n');
  }

  /// 🔄 GET con retry logic
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

  /// 🔄 POST con retry logic
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
      executor: () => http
          .post(url, headers: headers, body: body)
          .timeout(requestTimeout),
    );
  }

  /// 🔄 PUT con retry logic
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
      executor: () => http
          .put(url, headers: headers, body: body)
          .timeout(requestTimeout),
    );
  }

  /// 🔄 DELETE con retry logic
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
      executor: () => http.delete(url, headers: headers).timeout(requestTimeout),
    );
  }

  /// 🔄 Executor genérico con retry logic
  static Future<http.Response> _executeWithRetry({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    dynamic body,
    required bool enableRetry,
    required Future<http.Response> Function() executor,
  }) async {
    _logRequest(method, url, headers, body);
    
    int attempt = 0;
    Duration totalDuration = Duration.zero;
    
    while (attempt < (enableRetry ? maxRetries : 1)) {
      attempt++;
      final startTime = DateTime.now();
      
      try {
        final response = await executor();
        final duration = DateTime.now().difference(startTime);
        totalDuration += duration;
        
        _logResponse(method, url, response, duration);
        
        // ✅ Si es exitoso, retornar
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        
        // ⚠️ Si es error del cliente (4xx), NO reintentar
        if (response.statusCode >= 400 && response.statusCode < 500) {
          return response;
        }
        
        // 🔄 Si es error del servidor (5xx) y quedan intentos, reintentar
        if (response.statusCode >= 500 && attempt < maxRetries && enableRetry) {
          print('🔄 Reintentando en ${retryDelay.inSeconds}s... (Intento $attempt/$maxRetries)');
          await Future.delayed(retryDelay);
          continue;
        }
        
        return response;
        
      } on TimeoutException catch (e) {
        _logError(method, url, 'Timeout: $e', attempt);
        
        if (attempt < maxRetries && enableRetry) {
          print('🔄 Reintentando en ${retryDelay.inSeconds}s... (Intento $attempt/$maxRetries)');
          await Future.delayed(retryDelay);
          continue;
        }
        
        rethrow;
        
      } on SocketException catch (e) {
        _logError(method, url, 'No hay conexión a internet: $e', attempt);
        
        if (attempt < maxRetries && enableRetry) {
          print('🔄 Reintentando en ${retryDelay.inSeconds}s... (Intento $attempt/$maxRetries)');
          await Future.delayed(retryDelay);
          continue;
        }
        
        rethrow;
        
      } catch (e) {
        _logError(method, url, e, attempt);
        
        // Para otros errores, NO reintentar
        rethrow;
      }
    }
    
    throw Exception('Se agotaron los intentos después de $maxRetries reintentos');
  }

  /// 🚀 MultipartRequest con retry (para imágenes)
  static Future<http.StreamedResponse> sendMultipart(
    http.MultipartRequest request, {
    bool enableRetry = true,
  }) async {
    print('🌐 ═══════════════════════════════════════════════════════');
    print('📤 MULTIPART REQUEST: ${request.method} ${request.url.path}');
    print('🔗 URL: ${request.url}');
    print('📋 Fields: ${request.fields}');
    print('📎 Files: ${request.files.length}');
    print('═══════════════════════════════════════════════════════');

    int attempt = 0;
    
    while (attempt < (enableRetry ? maxRetries : 1)) {
      attempt++;
      final startTime = DateTime.now();
      
      try {
        final response = await request.send().timeout(requestTimeout);
        final duration = DateTime.now().difference(startTime);
        
        print('🌐 ═══════════════════════════════════════════════════════');
        print('${response.statusCode >= 200 && response.statusCode < 300 ? "✅" : "❌"} MULTIPART RESPONSE');
        print('📊 Status: ${response.statusCode}');
        print('⏱️ Duration: ${duration.inMilliseconds}ms');
        print('═══════════════════════════════════════════════════════\n');
        
        // ✅ Exitoso o error del cliente - retornar
        if (response.statusCode < 500) {
          return response;
        }
        
        // 🔄 Error del servidor - reintentar
        if (attempt < maxRetries && enableRetry) {
          print('🔄 Reintentando en ${retryDelay.inSeconds}s...');
          await Future.delayed(retryDelay);
          continue;
        }
        
        return response;
        
      } on TimeoutException catch (e) {
        _logError(request.method, request.url, 'Timeout: $e', attempt);
        
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        
        rethrow;
        
      } on SocketException catch (e) {
        _logError(request.method, request.url, 'Sin conexión: $e', attempt);
        
        if (attempt < maxRetries && enableRetry) {
          await Future.delayed(retryDelay);
          continue;
        }
        
        rethrow;
      }
    }
    
    throw Exception('Se agotaron los intentos después de $maxRetries reintentos');
  }
}