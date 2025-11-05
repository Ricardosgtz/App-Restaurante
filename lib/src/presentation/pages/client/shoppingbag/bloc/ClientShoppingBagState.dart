import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';

class ClientShoppingBagState extends Equatable {
  final List<Product> products;
  final double total;
  final int totalItems; // 👈 NUEVO: contador total de items
  final bool loading;
  final String? error;
  final Order? orderCreated;

  ClientShoppingBagState({
    this.products = const [],
    this.total = 0,
    this.totalItems = 0, // 👈 NUEVO
    this.loading = false,
    this.error,
    this.orderCreated,
  });

  ClientShoppingBagState copyWith({
    List<Product>? products,
    double? total,
    int? totalItems, // 👈 NUEVO
    bool? loading,
    String? error,
    Order? orderCreated,
  }) {
    return ClientShoppingBagState(
      products: products ?? this.products,
      total: total ?? this.total,
      totalItems: totalItems ?? this.totalItems, // 👈 NUEVO
      loading: loading ?? this.loading,
      error: error ?? this.error,
      orderCreated: orderCreated ?? this.orderCreated,
    );
  }

  @override
  List<Object?> get props => [products, total, totalItems, loading, error, orderCreated]; // 👈 Actualizado
}