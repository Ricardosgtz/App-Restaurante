import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';

class GetOrderDetailUseCase {
  OrdersRepository ordersRepository;

  GetOrderDetailUseCase(this.ordersRepository);

  run(int orderId) => ordersRepository.getOrderDetail(orderId);
}