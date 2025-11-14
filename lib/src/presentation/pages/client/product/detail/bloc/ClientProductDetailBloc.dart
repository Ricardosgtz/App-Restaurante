import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/ShoppingBagUseCases.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientProductDetailBloc
    extends Bloc<ClientProductDetailEvent, ClientProductDetailState> {
  final ShoppingBagUseCases shoppingBagUseCases;

  ClientProductDetailBloc(this.shoppingBagUseCases)
    : super(const ClientProductDetailState()) {
    on<GetProducts>(_onGetProducts);
    on<AddItem>(_onAddItem);
    on<SubtractItem>(_onSubtractItem);
    on<AddProductToShoppingBag>(_onAddProductToShoppingBag);
    on<ResetState>(_onResetState);
  }

  Future<void> _onGetProducts(
    GetProducts event,
    Emitter<ClientProductDetailState> emit,
  ) async {
    // Obtenemos todos los productos actuales en la bolsa
    final products = await shoppingBagUseCases.getProducts.run();
    final index = products.indexWhere((p) => p.id == event.product.id);

    emit(
      state.copyWith(
        quantity: index != -1 ? products[index].quantity : 0,
        shoppingBagProducts: products,
      ),
    );
  }

  Future<void> _onAddItem(
    AddItem event,
    Emitter<ClientProductDetailState> emit,
  ) async {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  Future<void> _onSubtractItem(
    SubtractItem event,
    Emitter<ClientProductDetailState> emit,
  ) async {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  Future<void> _onAddProductToShoppingBag(
    AddProductToShoppingBag event,
    Emitter<ClientProductDetailState> emit,
  ) async {
    final exists = state.shoppingBagProducts.any(
      (p) => p.id == event.product.id,
    );

    if (!exists) {
      // Si no existe, lo agregamos a la bolsa
      event.product.quantity = state.quantity;
      await shoppingBagUseCases.add.run(event.product);

      // Actualizamos la lista en el estado
      final updatedList = List<Product>.from(state.shoppingBagProducts)
        ..add(event.product);
      emit(state.copyWith(shoppingBagProducts: updatedList));
    } else {
      // Ya existe → no lo volvemos a agregar
      emit(state.copyWith());
    }
  }

  Future<void> _onResetState(
    ResetState event,
    Emitter<ClientProductDetailState> emit,
  ) async {
    emit(const ClientProductDetailState());
  }
}
