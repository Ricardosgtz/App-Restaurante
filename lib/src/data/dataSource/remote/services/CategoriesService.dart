import 'dart:convert';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;


class CategoriesService {

  Future<String> token;

  CategoriesService(this.token);

  Future<Resource<List<Category>>> getCategories() async {
    try {
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/categories/getCategories');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token,
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Category> categories = Category.fromJsonList(data);
        return Success(categories);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}
