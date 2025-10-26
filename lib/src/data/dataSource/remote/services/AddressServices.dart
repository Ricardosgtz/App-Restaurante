import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:http/http.dart' as http;

class AddressServices {
  final SharedPref _sharedPref = SharedPref();

  AddressServices(); // ✅ Sin parámetros

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

  Future<Resource<Address>> create(Address address, BuildContext context) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      print('Address: ${address.toJson()}');
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/address');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };
      String body = json.encode(address.toJson());
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      print('Status code: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Address addressResponse = Address.fromJson(data);
        return Success(addressResponse);
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

  Future<Resource<List<Address>>> getUserAddress(int idClient, BuildContext context) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/address/clients/$idClient');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Address> address = Address.fromJsonList(data);
        print('Address: $address');
        return Success(address);
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

  Future<Resource<bool>> delete(int id, BuildContext context) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/address/$id');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };
      final response = await http.delete(url, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
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