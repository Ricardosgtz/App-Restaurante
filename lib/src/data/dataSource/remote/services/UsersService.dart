import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/HttpClientHelper.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class UsersService extends BaseService {
  Future<Resource<Cliente>> update(
    int id,
    Cliente cliente,
    BuildContext context,
  ) async {
    try {
      final tokenValue = await validateAndGetToken(context);
      //if (tokenValue == null) return Error("Sesión expirada");
      final url = Uri.https(Apiconfig.API_ECOMMERCE, '/clients/$id');
      final headers = await getAuthHeaders();
      
      final body = json.encode({
        'name': cliente.name,
        'lastname': cliente.lastname,
        'phone': cliente.phone,
      });
      
      final response = await HttpClientHelper.put(
        url,
        headers: headers,
        body: body,
        enableRetry: true,
      );
      
      final result = await handleResponse<Cliente>(
        response: response,
        context: context,
        onSuccess: (data) {
          Cliente userResponse = Cliente.fromJson(data);
          invalidateCache('clients');
          return userResponse;
        },
      );
      
      return result;
    } catch (e) {
      print('❌ Error update: $e');
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
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) return Error("Sesión expirada");
      final url = Uri.https(Apiconfig.API_ECOMMERCE, '/clients/upload/$id');
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = tokenValue;

      request.files.add(
        http.MultipartFile(
          'file',
          http.ByteStream(file.openRead().cast()),
          await file.length(),
          filename: basename(file.path),
          contentType: MediaType('image', 'jpg'),
        ),
      );

      request.fields['name'] = cliente.name;
      request.fields['lastname'] = cliente.lastname;
      request.fields['phone'] = cliente.phone;

      final response = await HttpClientHelper.sendMultipart(
        request,
        enableRetry: true,
      );

      final result = await handleStreamedResponse<Cliente>(
        response: response,
        context: context,
        onSuccess: (data) {
          Cliente userResponse = Cliente.fromJson(data);
          invalidateCache('clients');
          return userResponse;
        },
      );
      return result;
    } catch (e) {
      print('❌ Error updateImage: $e');
      return Error(e.toString());
    }
  }
}