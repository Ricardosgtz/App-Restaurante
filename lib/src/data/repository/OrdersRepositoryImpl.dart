// 📁 src/data/repository/OrdersRepositoryImpl.dart

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersService ordersService;

  OrdersRepositoryImpl(this.ordersService);

  static const String _cacheKeyPrefix = 'orders_cache_client_';

  @override
  Future<Resource<List<Order>>> getOrdersByClient(
    int clientId,
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final String cacheKey = '$_cacheKeyPrefix$clientId';

      // Si NO se fuerza actualización, intentar mostrar caché local primero
      if (!forceRefresh && prefs.containsKey(cacheKey)) {
        final cachedString = prefs.getString(cacheKey);
        if (cachedString != null) {
          final List decoded = jsonDecode(cachedString);
          final List<Order> cachedOrders = decoded.map((o) => Order.fromJson(o)).toList();
          return Success(cachedOrders);
        }
      }

      // Consultar backend (usa caché en memoria + retry + expiración)
      final Resource<List<Order>> response = await ordersService
          .getOrdersByClient(clientId, context, forceRefresh: forceRefresh);

      // Si fue exitoso, guardar nuevas órdenes en caché
      if (response is Success<List<Order>>) {
        final orders = response.data;
        final String jsonString = jsonEncode(
          orders.map((o) => o.toJson()).toList(),
        );
        await prefs.setString(cacheKey, jsonString);
      }

      return response;
    } catch (e) {
      print('Error en OrdersRepositoryImpl.getOrdersByClient: $e');
      return Error('Error al obtener órdenes: $e');
    }
  }

  @override
  Future<Resource<Order>> getOrderDetail(int orderId, BuildContext context) {
    return ordersService.getOrderDetail(orderId, context);
  }

  @override
  Future<Resource<Order>> createOrder({
    required int clientId,
    BuildContext? context,
    required int restaurantId,
    required int statusId,
    int? addressId,
    required String orderType,
    String? note,
    required List<Map<String, dynamic>> items,
    String? arrivalTime,
  }) {
    return ordersService.createOrder(
      clientId: clientId,
      context: context!,
      restaurantId: restaurantId,
      statusId: statusId,
      addressId: addressId,
      orderType: orderType,
      note: note,
      items: items,
      arrivalTime: arrivalTime,
    );
  }
}
