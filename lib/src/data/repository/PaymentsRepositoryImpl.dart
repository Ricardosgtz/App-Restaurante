import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/PaymentsService.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/repository/PaymentsRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:injectable/injectable.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsService service;

  PaymentsRepositoryImpl(this.service);

  @override
  Future<Resource<Payment>> createPayment({
    required int orderId,
    required String paymentMethod,
    String? comprobantePath,
    required BuildContext context,
  }) {
    return service.createPayment(
      orderId: orderId,
      paymentMethod: paymentMethod,
      comprobantePath: comprobantePath,
      context: context,
    );
  }
}

