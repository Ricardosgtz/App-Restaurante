// lib/src/domain/repository/PaymentsRepository.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class PaymentsRepository {
  Future<Resource<Payment>> createPayment({
    required int orderId,
    required String paymentMethod,
    String? comprobantePath,
    required BuildContext context,
  });

  // 🆕 Nuevo método
  Future<Resource<Payment?>> getPaymentByOrderId({
    required int orderId,
    required BuildContext context,
  });
}