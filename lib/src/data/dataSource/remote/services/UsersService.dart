import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class UsersService {
  final SharedPref _sharedPref = SharedPref();

  UsersService(); // ✅ Sin parámetros

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

  Future<Resource<Cliente>> update(
    int id,
    Cliente cliente,
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

      print('METODO ACTUALIZAR SIN IMAGEN');
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/clients/$id');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };
      String body = json.encode({
        'name': cliente.name,
        'lastname': cliente.lastname,
        'phone': cliente.phone,
      });
      final response = await http.put(url, headers: headers, body: body);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Cliente userResponse = Cliente.fromJson(data);
        return Success(userResponse);
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

  Future<Resource<Cliente>> updateImage(
    int id,
    Cliente cliente,
    File file,
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

      print('📤 METODO ACTUALIZAR CON IMAGEN');
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/clients/upload/$id');

      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = tokenValue;

      // 🖼️ Archivo de imagen
      request.files.add(
        http.MultipartFile(
          'file',
          http.ByteStream(file.openRead().cast()),
          await file.length(),
          filename: basename(file.path),
          contentType: MediaType('image', 'jpg'),
        ),
      );

      // 📋 Campos normales (sin JSON)
      request.fields['name'] = cliente.name;
      request.fields['lastname'] = cliente.lastname;
      request.fields['phone'] = cliente.phone;

      // 🚀 Enviar
      final response = await request.send();
      print('🔁 RESPONSE STATUS: ${response.statusCode}');
      final responseString = await response.stream.transform(utf8.decoder).join();
      print('🔁 RESPONSE BODY: $responseString');

      final data = json.decode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Cliente userResponse = Cliente.fromJson(data);
        return Success(userResponse);
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('❌ Error: $e');
      return Error(e.toString());
    }
  }
}