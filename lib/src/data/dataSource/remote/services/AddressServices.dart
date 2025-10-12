import 'dart:convert';

import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class AddressServices{

  Future<String> token;
  
  AddressServices(this.token);

  Future<Resource<Address>> create(Address address) async {
    try {
      print('Address: ${address.toJson()}');
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/address');      
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      String body = json.encode(address.toJson());
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      print('Status code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Address addressResponse = Address.fromJson(data);
        return Success(addressResponse);
      }
      else { // ERROR
        return Error(ListToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<List<Address>>> getUserAddress(int idClient) async {
     try {
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/address/clients/$idClient'); 
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Address> address = Address.fromJsonList(data);
        print('Address: ${address}');
        return Success(address);
      }
      else { // ERROR
        return Error(ListToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<bool>> delete(int id) async {
     try {
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/address/$id');     
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      final response = await http.delete(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
      }
      else { // ERROR
        return Error(ListToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}