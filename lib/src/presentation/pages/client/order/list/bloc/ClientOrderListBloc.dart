import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientOrderListBloc
    extends Bloc<ClientOrderListEvent, ClientOrderListState> {
  final OrdersUseCases ordersUseCases;
  final AuthUseCases authUseCases;

  ClientOrderListBloc(this.ordersUseCases, this.authUseCases)
      : super(ClientOrderListState()) {
    on<GetOrders>(_onGetOrders);
    on<RefreshOrders>(_onRefreshOrders);
  }

  /// 🔹 Obtiene las órdenes del cliente autenticado (con caché + refresco)
  Future<void> _onGetOrders(
    GetOrders event,
    Emitter<ClientOrderListState> emit,
  ) async {
    // 🔸 1. Solo mostrar loading si no hay datos previos
    if (state.response is! Success) {
      emit(state.copyWith(response: Loading()));
    }

    try {
      final AuthResponse authResponse = await authUseCases.getUserSession.run();
      final int clientId = authResponse.cliente.id!;

      // 🔹 2. Primero intenta con caché (respuesta inmediata)
      final Resource cachedResponse = await ordersUseCases.getOrdersByClient.run(
        clientId: clientId,
        context: event.context,
        forceRefresh: true, // ✅ usa caché si está vigente (5 minutos)
      );

      emit(state.copyWith(response: cachedResponse));

      // 🔹 3. Luego refresca en background sin bloquear la UI
      Future.delayed(const Duration(milliseconds: 400), () async {
        try {
          final Resource refreshedResponse =
              await ordersUseCases.getOrdersByClient.run(
            clientId: clientId,
            context: event.context,
            forceRefresh: true, // 🔥 fuerza actualización silenciosa
          );

          // Solo emitir si hay cambios reales
          if (refreshedResponse is Success &&
              cachedResponse is Success &&
              refreshedResponse.data != cachedResponse.data) {
            emit(state.copyWith(response: refreshedResponse));
          }
        } catch (e) {
          print('⚠️ Error al refrescar en background: $e');
        }
      });
    } catch (e) {
      emit(state.copyWith(response: Error("Error al obtener las órdenes: $e")));
    }
  }

  /// 🔄 Refresca las órdenes manualmente (pull-to-refresh o botón)
  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<ClientOrderListState> emit,
  ) async {
    try {
      final AuthResponse authResponse = await authUseCases.getUserSession.run();
      final int clientId = authResponse.cliente.id!;

      final Resource response = await ordersUseCases.getOrdersByClient.run(
        clientId: clientId,
        context: event.context,
        forceRefresh: true, // ✅ en refresh manual siempre forzamos actualización
      );

      emit(state.copyWith(response: response));
    } catch (e) {
      emit(state.copyWith(response: Error("Error al refrescar órdenes: $e")));
    }
  }
}
