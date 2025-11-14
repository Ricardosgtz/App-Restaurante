import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/ShoppingBagUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/payments/PaymentsUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientShoppingBagBloc
    extends Bloc<ClientShoppingBagEvent, ClientShoppingBagState> {
  ShoppingBagUseCases shoppingBagUseCases;
  OrdersUseCases ordersUseCases;
  AuthUseCases authUseCases;
  PaymentsUseCases paymentsUseCases;

  ClientShoppingBagBloc(
    this.shoppingBagUseCases,
    this.ordersUseCases,
    this.authUseCases,
    this.paymentsUseCases,
  ) : super(ClientShoppingBagState()) {
    on<GetShoppingBag>(_onGetShoppingBag);
    on<AddItems>(_onAddItem);
    on<SubtractItems>(_onSubtractItem);
    on<RemoveItem>(_onRemoveItem);
    on<GetTotal>(_onGetTotal);
    on<ConfirmOrder>(_onConfirmOrder);
    on<ClearShoppingBag>(_onClearShoppingBag);
  }

  Future<void> _onGetShoppingBag(
    GetShoppingBag event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    List<Product> products = await shoppingBagUseCases.getProducts.run();
    int totalItems = _calculateTotalItems(products); //Calcular total items
    emit(
      state.copyWith(
        products: products,
        totalItems: totalItems, //Emitir total items
      ),
    );
    add(GetTotal());
  }

  Future<void> _onAddItem(
    AddItems event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    event.product.quantity = event.product.quantity! + 1;
    await shoppingBagUseCases.add.run(event.product);
    add(GetShoppingBag());
  }

  Future<void> _onSubtractItem(
    SubtractItems event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    if (event.product.quantity! > 1) {
      event.product.quantity = event.product.quantity! - 1;
      await shoppingBagUseCases.add.run(event.product);
      add(GetShoppingBag());
    }
  }

  Future<void> _onRemoveItem(
    RemoveItem event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    await shoppingBagUseCases.deleteItem.run(event.product);
    add(GetShoppingBag());
  }

  Future<void> _onGetTotal(
    GetTotal event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    double total = await shoppingBagUseCases.getTotal.run();
    emit(state.copyWith(total: total));
  }

  Future<void> _onConfirmOrder(
    ConfirmOrder event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final result = await ordersUseCases.createOrder.run(
        clientId: event.clientId,
        restaurantId: event.restaurantId,
        statusId: event.statusId,
        addressId: event.addressId,
        orderType: event.orderType,
        note: event.note,
        items: event.items,
      );

      if (result is Success) {
        //Limpiar carrito después de crear orden
        await shoppingBagUseCases.deleteShoppingBag.run();
        emit(
          state.copyWith(
            loading: false,
            orderCreated: result.data,
            products: [],
            total: 0,
            totalItems: 0, //Reset contador
          ),
        );
      } else if (result is Error) {
        emit(state.copyWith(loading: false, error: result.message));
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Error al crear la orden: ${e.toString()}',
        ),
      );
    }
  }

  // Limpiar carrito manualmente desde la UI
  Future<void> _onClearShoppingBag(
    ClearShoppingBag event,
    Emitter<ClientShoppingBagState> emit,
  ) async {
    await shoppingBagUseCases.deleteShoppingBag.run();
    emit(
      state.copyWith(
        products: [],
        total: 0,
        totalItems: 0, //Reset contador
      ),
    );
  }

  //Calcular el total de items (suma de cantidades)
  int _calculateTotalItems(List<Product> products) {
    return products.fold(0, (sum, product) => sum + (product.quantity ?? 1));
  }
}
