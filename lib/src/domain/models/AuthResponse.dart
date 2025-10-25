// To parse this JSON data, do
//
//     final authResponse = authResponseFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  
    Cliente cliente;
    String token;

    AuthResponse({
        required this.cliente,
        required this.token,
    });

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        cliente: Cliente.fromJson(json["cliente"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "cliente": cliente.toJson(),
        "token": token,
    };
}


