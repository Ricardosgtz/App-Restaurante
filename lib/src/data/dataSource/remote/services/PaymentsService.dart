import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PaymentsService extends BaseService {

  Future<Resource<Payment>> createPayment({
    required int orderId,
    required String paymentMethod,
    String? comprobantePath,
    required BuildContext context,
  }) async {
    try {
      // 🔑 Validar token antes de enviar
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) {
        return Error("Tu sesión ha expirado. Inicia sesión nuevamente.");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/payments');
      final headers = await getAuthHeaders();
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields['order_id'] = orderId.toString();
      request.fields['payment_method'] = paymentMethod;

      if (paymentMethod == 'transferencia' && comprobantePath != null) {
        File file = File(comprobantePath);
        final mimeType = comprobantePath.endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'comprobante',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return handleResponse<Payment>(
        response: response,
        context: context,
        onSuccess: (data) {
          Payment payment = Payment.fromJson(data['data']);
          return payment;
        },
      );
    } catch (e) {
      return Error("Error al crear el pago: $e");
    }
  }

  Future<Resource<Payment?>> getPaymentByOrderId({
    required int orderId,
    required BuildContext context,
  }) async {
    try {
      // 🔑 Validar token antes de enviar
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) {
        return Error("Tu sesión ha expirado. Inicia sesión nuevamente.");
      }

      Uri url = Uri.https(Apiconfig.API_ECOMMERCE, '/payments/order/$orderId/');
      final headers = await getAuthHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 404) {
        print('⚠️ No se encontró pago para la orden $orderId');
        return Success(null);
      }

      return handleResponse<Payment?>(
        response: response,
        context: context,
        onSuccess: (data) {
          if (data == null || data['data'] == null) {
            print('⚠️ No hay data en la respuesta');
            return null;
          }
          
          try {
            Payment payment = Payment.fromJson(data['data']);
            return payment;
          } catch (e) {
            return null;
          }
        },
      );
    } catch (e) {
      return Error("Error al obtener el pago: $e");
    }
  }
}


