import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';

class CreateOrderUseCase {
  OrdersRepository ordersRepository;

  CreateOrderUseCase(this.ordersRepository);

  run({
    required int clientId,
    required int restaurantId,
    required int statusId,
    int? addressId,
    required String orderType,
    String? note,
    required List<Map<String, dynamic>> items,
    String? arrivalTime,
  }) => ordersRepository.createOrder(
    clientId: clientId,
    restaurantId: restaurantId,
    statusId: statusId,
    addressId: addressId,
    orderType: orderType,
    note: note,
    items: items,
    arrivalTime: arrivalTime
  );
}