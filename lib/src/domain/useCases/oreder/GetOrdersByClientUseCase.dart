
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';

class GetOrdersByClientUseCase {
  OrdersRepository ordersRepository;

  GetOrdersByClientUseCase(this.ordersRepository);

  run(int clientId) => ordersRepository.getOrdersByClient(clientId);
}