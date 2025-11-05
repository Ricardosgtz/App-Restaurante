import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/repository/PaymentsRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class CreatePaymentUseCase {
  final PaymentsRepository repository;

  CreatePaymentUseCase(this.repository);

  Future<Resource<Payment>> run({
    required int orderId,
    required String paymentMethod,
    String? comprobantePath,
    required BuildContext context,
  }) {
    return repository.createPayment(
      orderId: orderId,
      paymentMethod: paymentMethod,
      comprobantePath: comprobantePath,
      context: context,
    );
  }
}
