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

  Future<void> _onGetOrders(
    GetOrders event,
    Emitter<ClientOrderListState> emit,
  ) async {
    if (state.response is! Success) {
      emit(state.copyWith(response: Loading()));
    }

    try {
      final AuthResponse authResponse = await authUseCases.getUserSession.run();
      final int clientId = authResponse.cliente.id!;

      final Resource<List<dynamic>> cachedResponse = await ordersUseCases
          .getOrdersByClient
          .run(clientId: clientId, context: event.context, forceRefresh: false);

      if (cachedResponse is Success && state.response is! Success) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      emit(state.copyWith(response: cachedResponse));

      Future.microtask(() async {
        try {
          final Resource<List<dynamic>> refreshedResponse = await ordersUseCases
              .getOrdersByClient
              .run(
                clientId: clientId,
                context: event.context,
                forceRefresh: true,
              );

          if (refreshedResponse is Success<List<dynamic>>) {
            final newData = refreshedResponse.data;
            final oldData =
                (cachedResponse is Success<List<dynamic>>)
                    ? cachedResponse.data
                    : [];

            if (newData.length != oldData.length ||
                newData.toString() != oldData.toString()) {
              emit(state.copyWith(response: refreshedResponse));
            }
          }
        } catch (_) {}
      });
    } catch (e) {
      emit(state.copyWith(response: Error('Error al obtener órdenes: $e')));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<ClientOrderListState> emit,
  ) async {
    try {
      final AuthResponse authResponse = await authUseCases.getUserSession.run();
      final int clientId = authResponse.cliente.id!;

      final Resource<List<dynamic>> response = await ordersUseCases
          .getOrdersByClient
          .run(clientId: clientId, context: event.context, forceRefresh: true);

      emit(state.copyWith(response: response));
    } catch (e) {
      emit(state.copyWith(response: Error('Error al refrescar órdenes: $e')));
    }
  }
}
