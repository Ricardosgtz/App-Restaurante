import 'dart:convert';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';

class AuthService {
  final SharedPref _sharedPref = SharedPref();
  final ResponseCache _cache = ResponseCache();

  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      await _clearPreviousSession();
      
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/auth/login');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode({'email': email, 'password': password});

      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        await _sharedPref.save('cliente', authResponse.toJson());
        return Success(authResponse);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error en login: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<AuthResponse>> register(Cliente cliente) async {
    try {
      await _clearPreviousSession();
      
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/auth/register');
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = json.encode(cliente);
      
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        await _sharedPref.save('cliente', authResponse.toJson());
        print('✅ Nueva sesión guardada correctamente');
        
        return Success(authResponse);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error en register: $e');
      return Error(e.toString());
    }
  }
  /// Limpia completamente la sesión anterior
  Future<void> _clearPreviousSession() async {
    try {
      // Limpiar SharedPrefs
      final keysToRemove = [
        'cliente',
        'user',
        'cart',
        'shopping_bag',
        'favorites',
        'last_address',
        'selected_category',
        'orders_cache',
        'products_cache',
      ];

      for (final key in keysToRemove) {
        await _sharedPref.remove(key);
      }

      _cache.clear();
      
    } catch (e) {
      await _sharedPref.remove('cliente');
      await _sharedPref.remove('user');
      _cache.clear();
    }
  }
  Future<void> logout() async {
    await _clearPreviousSession();
  }
}