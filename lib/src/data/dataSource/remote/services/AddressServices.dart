import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/HttpClientHelper.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

/// 📍 Servicio de Direcciones
/// Con caché, retry logic, y logging automático
class AddressServices extends BaseService {
  
  /// 📍 Crear nueva dirección
  /// ✅ Sin caché (mutación)
  /// ✅ Invalida caché de direcciones después de crear
  Future<Resource<Address>> create(Address address, BuildContext context) async {
    try {
      final tokenValue = await validateAndGetToken(context);
      //if (tokenValue == null) return Error("Sesión expirada");

      print('📍 Creando dirección: ${address.toJson()}');
      
      final url = Uri.https(Apiconfig.API_ECOMMERCE, '/address');
      final headers = await getAuthHeaders();
      final body = json.encode(address.toJson());
      
      // Usar HttpClientHelper para retry automático
      final response = await HttpClientHelper.post(
        url,
        headers: headers,
        body: body,
        enableRetry: true,
      );
      
      final result = await handleResponse<Address>(
        response: response,
        context: context,
        onSuccess: (data) {
          final newAddress = Address.fromJson(data);
          
          // 🧹 Invalidar caché de direcciones
          invalidateCache('address');
          
          print('✅ Dirección creada: ${newAddress.id}');
          return newAddress;
        },
      );
      
      return result;
    } catch (e) {
      print('❌ Error create address: $e');
      return Error(e.toString());
    }
  }

  /// 📋 Obtener direcciones del usuario
  /// ✅ Caché de 30 minutos
  /// ✅ Retry automático
  Future<Resource<List<Address>>> getUserAddress(
    int idClient,
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    try {
      final url = 'https://${Apiconfig.API_ECOMMERCE}/address/clients/$idClient';
      
      return await getCached<List<Address>>(
        url: url,
        context: context,
        onSuccess: (data) {
          List<Address> addresses = Address.fromJsonList(data);
          print('📍 Addresses loaded: ${addresses.length}');
          return addresses;
        },
        cacheDuration: CacheDuration.userProfile, // 30 minutos
        useCache: !forceRefresh,
        enableRetry: true,
      );
    } catch (e) {
      print('❌ Error getUserAddress: $e');
      return Error(e.toString());
    }
  }

  /// 🗑️ Eliminar dirección
  /// ✅ Sin caché (mutación)
  /// ✅ Invalida caché después de eliminar
  Future<Resource<bool>> delete(int id, BuildContext context) async {
    try {
      final tokenValue = await validateAndGetToken(context);
      if (tokenValue == null) return Error("Sesión expirada");

      print('🗑️ Eliminando dirección: $id');
      
      final url = Uri.https(Apiconfig.API_ECOMMERCE, '/address/$id');
      final headers = await getAuthHeaders();
      
      final response = await HttpClientHelper.delete(
        url,
        headers: headers,
        enableRetry: true,
      );
      
      final result = await handleResponse<bool>(
        response: response,
        context: context,
        onSuccess: (_) {
          // 🧹 Invalidar caché de direcciones
          invalidateCache('address');
          
          print('✅ Dirección eliminada: $id');
          return true;
        },
      );
      
      return result;
    } catch (e) {
      print('❌ Error delete address: $e');
      return Error(e.toString());
    }
  }

  /// 🔄 Refrescar direcciones
  Future<Resource<List<Address>>> refreshAddresses(
    int idClient,
    BuildContext context,
  ) async {
    invalidateCache('address');
    return getUserAddress(idClient, context, forceRefresh: true);
  }
}