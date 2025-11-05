// 📁 src/data/repository/OrdersRepositoryImpl.dart (o donde esté)

import 'package:flutter/widgets.dart'; // ⚠️ Corregí el nombre: OrdersService (singular)
import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersService ordersService; // 👈 final y correcto nombre

  OrdersRepositoryImpl(this.ordersService);

  @override
  Future<Resource<List<Order>>> getOrdersByClient(
    int clientId,
    BuildContext context, {
    bool forceRefresh = false, // 👈 lo recibimos
  }) {
    return ordersService.getOrdersByClient(
      clientId,
      context,
      forceRefresh: forceRefresh, // 👈 y lo pasamos
    );
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
    String? arrivalTime
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
      arrivalTime: arrivalTime
    );
  }
}