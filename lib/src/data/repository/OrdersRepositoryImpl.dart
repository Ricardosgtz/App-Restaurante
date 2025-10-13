import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class OrdersRepositoryImpl implements OrdersRepository {

  OrdersService ordersService;

  OrdersRepositoryImpl(this.ordersService);

  @override
  Future<Resource<List<Order>>> getOrdersByClient(int clientId) {
    return ordersService.getOrdersByClient(clientId);
  }

  @override
  Future<Resource<Order>> getOrderDetail(int orderId) {
    return ordersService.getOrderDetail(orderId);
  }

  @override
  Future<Resource<Order>> createOrder({
    required int clientId,
    required int restaurantId,
    required int statusId,
    int? addressId,
    required String orderType,
    String? note,
    required List<Map<String, dynamic>> items,
  }) {
    return ordersService.createOrder(
      clientId: clientId,
      restaurantId: restaurantId,
      statusId: statusId,
      addressId: addressId,
      orderType: orderType,
      note: note,
      items: items,
    );
  }
}