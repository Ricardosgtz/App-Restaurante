// 📁 src/domain/repository/OrdersRepository.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class OrdersRepository {
  Future<Resource<List<Order>>> getOrdersByClient(
    int clientId,
    BuildContext context, {
    bool forceRefresh = false, // 👈 nuevo parámetro opcional
  });

  Future<Resource<Order>> getOrderDetail(int orderId, BuildContext context);

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
  });
}