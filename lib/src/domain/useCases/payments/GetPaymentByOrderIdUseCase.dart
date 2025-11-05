// lib/src/domain/useCases/payments/GetPaymentByOrderIdUseCase.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/repository/PaymentsRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class GetPaymentByOrderIdUseCase {
  final PaymentsRepository repository;

  GetPaymentByOrderIdUseCase(this.repository);

  Future<Resource<Payment?>> run({
    required int orderId,
    required BuildContext context,
  }) {
    return repository.getPaymentByOrderId(
      orderId: orderId,
      context: context,
    );
  }
}