import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class OrdersRepositoryImpl implements OrdersRepository {

  OrdersService ordersService;

  OrdersRepositoryImpl(this.ordersService);

  @override
  Future<Resource<List<Order>>> getOrdersByClient(int clientId, BuildContext context) {
    return ordersService.getOrdersByClient(clientId, context);
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
  }) {
    return ordersService.createOrder(
      clientId: clientId,
      context: context,
      restaurantId: restaurantId,
      statusId: statusId,
      addressId: addressId,
      orderType: orderType,
      note: note,
      items: items,
    );
  }
}