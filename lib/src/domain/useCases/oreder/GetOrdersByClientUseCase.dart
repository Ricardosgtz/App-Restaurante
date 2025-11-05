// 📁 GetOrdersByClientUseCase.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';

class GetOrdersByClientUseCase {
  final OrdersRepository ordersRepository;

  GetOrdersByClientUseCase(this.ordersRepository);

  run({
    required int clientId,
    required BuildContext context,
    bool forceRefresh = false,
  }) {
    return ordersRepository.getOrdersByClient(
      clientId,
      context,
      forceRefresh: forceRefresh,
    );
  }
}