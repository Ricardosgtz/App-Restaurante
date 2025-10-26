import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:http/http.dart' as http;

class OrdersService {
  final SharedPref _sharedPref = SharedPref();

  OrdersService(); // ✅ Sin parámetros

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

  /// Obtiene todas las órdenes de un cliente específico
  Future<Resource<List<Order>>> getOrdersByClient(int clientId, BuildContext context) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/orders/client/$clientId');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };

      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final list = (data is List) ? data : (data['data'] ?? []);
        List<Order> orders = (list as List)
            .map((item) => Order.fromJson(item as Map<String, dynamic>))
            .toList();
        return Success(orders);
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else {
        return Error(ListToString(data['message'] ?? 'Error desconocido'));
      }
    } catch (e) {
      print('❌ Error getOrdersByClient: $e');
      return Error('Error al obtener las órdenes: $e');
    }
  }

  /// Obtiene el detalle completo de una orden específica
  Future<Resource<Order>> getOrderDetail(int orderId, BuildContext context) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/orders/$orderId');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };

      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Order order = Order.fromJson(data);
        return Success(order);
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error getOrderDetail: $e');
      return Error(e.toString());
    }
  }

  /// Crea una nueva orden
  Future<Resource<Order>> createOrder({
    required int clientId,
    required int restaurantId,
    required int statusId,
    int? addressId,
    required String orderType,
    String? note,
    required List<Map<String, dynamic>> items,
    required BuildContext? context,
  }) async {
    try {
      final tokenValue = await _getToken();
      
      if (tokenValue == null) {
        if (context!.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/orders');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": tokenValue,
      };

      Map<String, dynamic> body = {
        "client": clientId,
        "restaurant": restaurantId,
        "status": statusId,
        "order_type": orderType,
        "note": note ?? "",
        "items": items,
      };

      if (orderType == "domicilio" && addressId != null) {
        body["address"] = addressId;
      }

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Order order = Order.fromJson(data);
        return Success(order);
      } else if (response.statusCode == 401) {
        if (context!.mounted) {
          await AuthExpiredHandler.handleUnauthorized(context);
        }
        return Error("Sesión expirada");
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error createOrder: $e');
      return Error(e.toString());
    }
  }
}