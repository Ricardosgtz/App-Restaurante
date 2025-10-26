import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:http/http.dart' as http;

class ProductsService {
  final SharedPref _sharedPref = SharedPref();

  ProductsService(); // ✅ Sin parámetros

  /// 🔑 Obtener token fresco
  Future<String?> _getToken() async {
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

  Future<Resource<List<Product>>> getProductByCategory(
    int idCategory,
    BuildContext context,
  ) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      Uri url = Uri.https(
        Apiconfig.API_ECOMMERCE,
        '/products/category/$idCategory',
      );
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Product> products = Product.fromJsonList(data);
        return Success(products);
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}