import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';

class ClientProductDetailState extends Equatable {
  final int quantity;
  final List<Product> shoppingBagProducts;

  const ClientProductDetailState({
    this.quantity = 0,
    this.shoppingBagProducts = const [],
  });

  ClientProductDetailState copyWith({
    int? quantity,
    List<Product>? shoppingBagProducts,
  }) {
    return ClientProductDetailState(
      quantity: quantity ?? this.quantity,
      shoppingBagProducts: shoppingBagProducts ?? this.shoppingBagProducts,
    );
  }

  @override
  List<Object?> get props => [quantity, shoppingBagProducts];
}
