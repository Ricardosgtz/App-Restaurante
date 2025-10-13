
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class OrdersRepository {

  /// Obtiene todas las órdenes de un cliente específico
  Future<Resource<List<Order>>> getOrdersByClient(int clientId);

  /// Obtiene el detalle completo de una orden específica
  Future<Resource<Order>> getOrderDetail(int orderId);

  /// Crea una nueva orden
  Future<Resource<Order>> createOrder({
    required int clientId,
    required int restaurantId,
    required int statusId,
    int? addressId,
    required String orderType,
    String? note,
    required List<Map<String, dynamic>> items,
  });
}