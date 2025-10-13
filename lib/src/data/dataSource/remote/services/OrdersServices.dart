import 'dart:convert';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class OrdersService {

  Future<String> token;

  OrdersService(this.token);

  /// Obtiene todas las órdenes de un cliente específico
  Future<Resource<List<Order>>> getOrdersByClient(int clientId) async {
    try {
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/orders/client/$clientId/');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Order> orders = orderFromJson(json.encode(data));
        return Success(orders);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error getOrdersByClient: $e');
      return Error(e.toString());
    }
  }

  /// Obtiene el detalle completo de una orden específica
  Future<Resource<Order>> getOrderDetail(int orderId) async {
    try {
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/orders/$orderId/');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Order order = Order.fromJson(data);
        return Success(order);
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
  }) async {
    try {
      Uri url = Uri.http(Apiconfig.API_ECOMMERCE, '/orders/');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };

      // Construir el body de la solicitud
      Map<String, dynamic> body = {
        "client": clientId,
        "restaurant": restaurantId,
        "status": statusId,
        "order_type": orderType,
        "note": note ?? "",
        "items": items,
      };

      // Agregar address solo si es domicilio y existe
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
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error createOrder: $e');
      return Error(e.toString());
    }
  }
}