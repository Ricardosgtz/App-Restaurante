import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';


class CategoriesService {
  final SharedPref _sharedPref = SharedPref();

  // ✅ REMOVIDO: Ya no guardamos el token como propiedad
  // Future<String> token; ❌

  CategoriesService(); // ✅ Constructor sin parámetros

  /// 🔑 Método privado para obtener el token FRESCO de SharedPrefs
  Future<String?> _getToken() async {
    try {
      final data = await _sharedPref.read('cliente');
      if (data != null) {
        final authResponse = AuthResponse.fromJson(data);
        
        // ✅ Verificar si el token no está expirado
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

  /// ✅ Obtiene la lista de categorías con manejo automático del 401
  Future<Resource<List<Category>>> getCategories(BuildContext context) async {
    try {
      // 🔑 Leer el token FRESCO en cada petición
      final tokenValue = await _getToken();
      
      // ✅ Si no hay token válido, retornar error sin hacer la petición
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada, inicia sesión nuevamente.");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/categories/getCategories');

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue, // ✅ Usar el token fresco
      };

      final response = await http.get(url, headers: headers);

      // Decodifica la respuesta
      final data = json.decode(response.body);

      // ✅ Caso exitoso
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Category> categories = Category.fromJsonList(data);
        return Success(categories);
      }
      // ⚠️ Token expirado o no autorizado
      else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada, inicia sesión nuevamente.");
      }
      // ❌ Otros errores
      else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error en getCategories: $e');
      return Error(e.toString());
    }
  }
}

