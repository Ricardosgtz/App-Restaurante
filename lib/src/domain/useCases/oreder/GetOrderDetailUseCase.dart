import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';

class GetOrderDetailUseCase {
  OrdersRepository ordersRepository;

  GetOrderDetailUseCase(this.ordersRepository);

  run(int orderId, BuildContext context) => ordersRepository.getOrderDetail(orderId, context);
}