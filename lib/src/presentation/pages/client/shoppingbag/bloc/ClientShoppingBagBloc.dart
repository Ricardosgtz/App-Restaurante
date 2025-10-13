import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/ShoppingBagUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientShoppingBagBloc extends Bloc<ClientShoppingBagEvent, ClientShoppingBagState> {

  ShoppingBagUseCases shoppingBagUseCases;
  OrdersUseCases ordersUseCases;

  ClientShoppingBagBloc(this.shoppingBagUseCases, this.ordersUseCases): super(ClientShoppingBagState()) {
    on<GetShoppingBag>(_onGetShoppingBag);
    on<AddItem>(_onAddItem);
    on<SubtractItem>(_onSubtractItem);
    on<RemoveItem>(_onRemoveItem);
    on<GetTotal>(_onGetTotal);
    on<ConfirmOrder>(_onConfirmOrder);
  }

  Future<void> _onGetShoppingBag(GetShoppingBag event, Emitter<ClientShoppingBagState> emit) async {
    List<Product> products = await shoppingBagUseCases.getProducts.run();
    emit(
      state.copyWith(products: products)
    );
    add(GetTotal());
  }

  Future<void> _onAddItem(AddItem event, Emitter<ClientShoppingBagState> emit) async {
    event.product.quantity = event.product.quantity! + 1;
    await shoppingBagUseCases.add.run(event.product);
    add(GetShoppingBag());
  }

  Future<void> _onSubtractItem(SubtractItem event, Emitter<ClientShoppingBagState> emit) async {
    if (event.product.quantity! > 1) {
      event.product.quantity = event.product.quantity! - 1;
      await shoppingBagUseCases.add.run(event.product);
      add(GetShoppingBag());
    }
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter<ClientShoppingBagState> emit) async {
    await shoppingBagUseCases.deleteItem.run(event.product);
    add(GetShoppingBag());
  }

  Future<void> _onGetTotal(GetTotal event, Emitter<ClientShoppingBagState> emit) async {
    double total = await shoppingBagUseCases.getTotal.run();
    emit(
      state.copyWith(total: total)
    );
  }

  Future<void> _onConfirmOrder(ConfirmOrder event, Emitter<ClientShoppingBagState> emit) async {
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
        // Limpiar el carrito después de crear la orden exitosamente
        await shoppingBagUseCases.deleteShoppingBag.run();
        
        emit(state.copyWith(
          loading: false,
          orderCreated: result.data,
          products: [],
          total: 0,
        ));
      } else if (result is Error) {
        emit(state.copyWith(
          loading: false,
          error: result.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'Error al crear la orden: ${e.toString()}',
      ));
    }
  }
}