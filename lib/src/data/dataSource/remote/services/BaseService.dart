import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';

/// 🎯 Clase base para todos los servicios
/// Centraliza la lógica de obtención y validación de tokens
abstract class BaseService {
  final SharedPref _sharedPref = SharedPref();

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
      print('Error obteniendo token: $e');
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
}