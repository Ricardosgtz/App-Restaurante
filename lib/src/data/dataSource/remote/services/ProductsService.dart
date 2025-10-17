import 'dart:convert';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class ProductsService {
  Future<String> token;

  ProductsService(this.token);

  Future<Resource<List<Product>>> getProductByCategory(int idCategory) async {
    try {
      Uri url = Uri.https(
        Apiconfig.API_ECOMMERCE,
        '/products/category/$idCategory',
      );
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token,
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Product> products = Product.fromJsonList(data);
        return Success(products);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

}
