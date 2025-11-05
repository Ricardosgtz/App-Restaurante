import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class CategoriesService extends BaseService {
  
  /// 📂 Obtener todas las categorías
  Future<Resource<List<Category>>> getCategories(BuildContext context) async {
    try {
      // ✅ Validar token antes de la petición
      final tokenValue = await validateAndGetToken(context);
      //if (tokenValue == null) {
      //  return Error("Sesión expirada, inicia sesión nuevamente.");
      //}

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/categories/getCategories');
      final headers = await getAuthHeaders();

      final response = await http.get(url, headers: headers);

      // ✅ Usar método centralizado para manejar la respuesta
      return handleResponse<List<Category>>(
        response: response,
        context: context,
        onSuccess: (data) {
          List<Category> categories = Category.fromJsonList(data);
          print('📂 Categories loaded: ${categories.length}');
          return categories;
        },
      );
    } catch (e) {
      print('❌ Error en getCategories: $e');
      return Error(e.toString());
    }
  }
}