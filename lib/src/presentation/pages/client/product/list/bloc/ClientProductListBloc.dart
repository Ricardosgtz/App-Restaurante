import 'package:flutter_application_1/src/domain/useCases/products/ProductsUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientProductListBloc
    extends Bloc<ClientProductListEvent, ClientProductListState> {
  ProductsUseCases productsUseCases;

  ClientProductListBloc(this.productsUseCases)
    : super(ClientProductListState()) {
    on<GetProductsByCategory>(_onGetProductsByCategory);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onGetProductsByCategory(
    GetProductsByCategory event,
    Emitter<ClientProductListState> emit,
  ) async {
    emit(state.copyWith(response: Loading()));
    Resource response = await productsUseCases.getProductsByCategory.run(
      idCategory: event.idCategory,
      context: event.context,
      forceRefresh: true,
    );
    emit(state.copyWith(response: response));
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ClientProductListState> emit,
  ) async {
    // Mantén el estado actual, pero muestra un loading interno si quieres
    final response = await productsUseCases.getProductsByCategory.run(
      idCategory: event.idCategory,
      context: event.context,
      forceRefresh: true,
    );
    emit(state.copyWith(response: response));
  }
}
