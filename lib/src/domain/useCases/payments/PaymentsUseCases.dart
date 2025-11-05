import 'package:flutter_application_1/src/domain/useCases/payments/CreatePaymentUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/payments/GetPaymentByOrderIdUseCase.dart';

class PaymentsUseCases {
  final CreatePaymentUseCase createPayment;
  final GetPaymentByOrderIdUseCase getPaymentByOrderId;

  PaymentsUseCases({
    required this.createPayment,
    required this.getPaymentByOrderId
  });
}
