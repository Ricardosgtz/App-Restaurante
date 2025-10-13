import 'package:flutter_application_1/src/domain/useCases/oreder/CreateOrderUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/GetOrderDetailUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/GetOrdersByClientUseCase.dart';

class OrdersUseCases {

  GetOrdersByClientUseCase getOrdersByClient;
  GetOrderDetailUseCase getOrderDetail;
  CreateOrderUseCase createOrder;

  OrdersUseCases({
    required this.getOrdersByClient,
    required this.getOrderDetail,
    required this.createOrder,
  });

}