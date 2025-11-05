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
}
