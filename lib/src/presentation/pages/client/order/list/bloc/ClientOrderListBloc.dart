
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientOrderListBloc extends Bloc<ClientOrderListEvent, ClientOrderListState> {
  final OrdersUseCases ordersUseCases;
  final AuthUseCases authUseCases;

  ClientOrderListBloc(this.ordersUseCases, this.authUseCases)
      : super(ClientOrderListState()) {
    on<GetOrders>(_onGetOrders);
    on<RefreshOrders>(_onRefreshOrders);
  }

  /// 🔹 Obtiene las órdenes del cliente autenticado
  Future<void> _onGetOrders(
    GetOrders event,
    Emitter<ClientOrderListState> emit,
  ) async {
    emit(state.copyWith(response: Loading()));

    try {
      // ✅ 1. Obtener sesión del usuario
      final AuthResponse authResponse = await authUseCases.getUserSession.run();
      final int clientId = authResponse.cliente.id!;

      // ✅ 2. Consultar órdenes del cliente
      final Resource response = await ordersUseCases.getOrdersByClient.run(clientId);

      // ✅ 3. Emitir resultado
      emit(state.copyWith(response: response));
    } catch (e) {
      // 🔥 Si ocurre un error inesperado
      emit(state.copyWith(response: Error("Error al obtener las órdenes: $e")));
    }
  }

  /// 🔄 Refresca las órdenes (sin mostrar loading completo)
  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<ClientOrderListState> emit,
  ) async {
    try {
      final AuthResponse authResponse = await authUseCases.getUserSession.run();
      final int clientId = authResponse.cliente.id!;

      final Resource response = await ordersUseCases.getOrdersByClient.run(clientId);

      emit(state.copyWith(response: response));
    } catch (e) {
      emit(state.copyWith(response: Error("Error al refrescar órdenes: $e")));
    }
  }
}
