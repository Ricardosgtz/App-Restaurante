import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class CategoriesService {
  Future<String> token;
  final SharedPref _sharedPref = SharedPref();

  CategoriesService(this.token);

  /// ✅ Obtiene la lista de categorías con manejo automático del 401
  Future<Resource<List<Category>>> getCategories(BuildContext context) async {
    try {
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/categories/getCategories');

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token,
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
        await AuthExpiredHandler.handleUnauthorized(context);
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
