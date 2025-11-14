import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/HttpClientHelper.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class OrdersService extends BaseService {

  Future<Resource<List<Order>>> getOrdersByClient(
    int clientId,
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    try {
      final url = 'https://${Apiconfig.API_ECOMMERCE}/orders/client/$clientId';

      return await getCached<List<Order>>(
        url: url,
        context: context,
        onSuccess: (data) {
          // Manejo flexible de la respuesta (array directo o dentro de 'data')
          final list = (data is List) ? data : (data['data'] ?? []);
          List<Order> orders =
              (list as List)
                  .map((item) => Order.fromJson(item as Map<String, dynamic>))
                  .toList();
          return orders;
        },
        cacheDuration: CacheDuration.orders, 
        useCache: !forceRefresh,
        enableRetry: true,
      );
    } catch (e) {
      return Error('Error al obtener las órdenes: $e');
    }
  }

  Future<Resource<Order>> getOrderDetail(
    int orderId,
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    try {
      final url = 'https://${Apiconfig.API_ECOMMERCE}/orders/$orderId';

      return await getCached<Order>(
        url: url,
        context: context,
        onSuccess: (data) {
          Order order = Order.fromJson(data);
          return order;
        },
        cacheDuration: CacheDuration.orders,
        useCache: !forceRefresh,
        enableRetry: true,
      );
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> createOrder({
    required int clientId,
    required int restaurantId,
    required int statusId,
    int? addressId,
    required String orderType,
    String? note,
    required List<Map<String, dynamic>> items,
    String? arrivalTime,
    required BuildContext context,
  }) async {
    try {
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) return Error("Sesión expirada");
      final url = Uri.https(Apiconfig.API_ECOMMERCE, '/orders');
      final headers = await getAuthHeaders();

      // Construir el body de la petición
      Map<String, dynamic> body = {
        "client": clientId,
        "restaurant": restaurantId,
        "status": statusId,
        "order_type": orderType,
        "note": note ?? "",
        "items": items,
      };

      //Agregar dirección solo si es domicilio
      if (orderType == "domicilio" && addressId != null) {
        body["address"] = addressId;
      }

      //Agregar hora de llegada solo si es anticipado
      if (orderType == "anticipado" &&
          arrivalTime != null &&
          arrivalTime.isNotEmpty) {
        // Django espera formato "HH:mm" o "HH:mm:ss"
        body["arrival_time"] = arrivalTime;
      }

      final response = await HttpClientHelper.post(
        url,
        headers: headers,
        body: json.encode(body),
        enableRetry: true,
      );

      final result = await handleResponse<Order>(
        response: response,
        context: context,
        onSuccess: (data) {
          Order order = Order.fromJson(data);
          invalidateCache('orders');
          return order;
        },
      );

      return result;
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<List<Order>>> refreshOrders(
    int clientId,
    BuildContext context,
  ) async {
    invalidateCache('orders');
    return getOrdersByClient(clientId, context, forceRefresh: true);
  }
}
