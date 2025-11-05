import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PaymentsService extends BaseService {
  
  /// 💳 Crear un pago (efectivo o transferencia)
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

      // 🧾 Construir solicitud multipart (para soportar imagen opcional)
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      // Campos obligatorios
      request.fields['order_id'] = orderId.toString();
      request.fields['payment_method'] = paymentMethod;

      // 🖼️ Agregar comprobante si aplica
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

      // 🔥 Enviar petición
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return handleResponse<Payment>(
        response: response,
        context: context,
        onSuccess: (data) {
          Payment payment = Payment.fromJson(data['data']);
          print('💰 Pago creado correctamente: ID ${payment.id}');
          return payment;
        },
      );
    } catch (e) {
      print('❌ Error en createPayment: $e');
      return Error("Error al crear el pago: $e");
    }
  }

  /// 📋 Obtener pago por order_id
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

      print('🔍 Solicitando pago para order_id: $orderId');
      print('🔍 URL: $url');

      final response = await http.get(url, headers: headers);

      print('📋 Response status: ${response.statusCode}');
      print('📋 Response body: ${response.body}');

      // Si el pago no existe (404), retornar Success con null
      if (response.statusCode == 404) {
        print('⚠️ No se encontró pago para la orden $orderId');
        return Success(null);
      }

      return handleResponse<Payment?>(
        response: response,
        context: context,
        onSuccess: (data) {
          // El backend devuelve {"message": "...", "statusCode": 200, "data": {...}}
          if (data == null || data['data'] == null) {
            print('⚠️ No hay data en la respuesta');
            return null;
          }
          
          try {
            Payment payment = Payment.fromJson(data['data']);
            print('💰 Pago obtenido correctamente: ID ${payment.id}, Status: ${payment.status}');
            return payment;
          } catch (e) {
            print('❌ Error al parsear Payment: $e');
            return null;
          }
        },
      );
    } catch (e) {
      print('❌ Error en getPaymentByOrderId: $e');
      return Error("Error al obtener el pago: $e");
    }
  }
}


