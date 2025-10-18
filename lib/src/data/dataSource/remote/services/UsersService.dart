import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class UsersService {
  Future<String> token;

  UsersService(this.token);

  Future<Resource<Cliente>> update(int id, Cliente cliente) async {
    try {
      print('METODO ACTUALIZAR SIN IMAGEN');
      // http://192.168.80.13:3000/users/5
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/clients/$id');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token,
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
      } else {
        // ERROR
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
  ) async {
    try {
      print('📤 METODO ACTUALIZAR CON IMAGEN');
      // 🔗 Usa tu dominio render
      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/clients/upload/$id');

      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = await token;

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
      final responseString =
          await response.stream.transform(utf8.decoder).join();
      print('🔁 RESPONSE BODY: $responseString');

      // 📦 Intentar decodificar JSON
      final data = json.decode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Cliente userResponse = Cliente.fromJson(data);
        return Success(userResponse);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('❌ Error: $e');
      return Error(e.toString());
    }
  }
}
