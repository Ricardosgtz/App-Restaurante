import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Eventos para la lista de productos del cliente
abstract class ClientProductListEvent extends Equatable {
  const ClientProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Obtener los productos según la categoría
class GetProductsByCategory extends ClientProductListEvent {
  final int idCategory;
  final BuildContext context;

  const GetProductsByCategory({
    required this.idCategory,
    required this.context,
  });

  @override
  List<Object?> get props => [idCategory];
}

/// Refrescar los productos de una categoría sin mostrar loading completo
class RefreshProducts extends ClientProductListEvent {
  final int idCategory;
  final BuildContext context;
  const RefreshProducts({required this.idCategory, required this.context});

  @override
  List<Object?> get props => [idCategory];
}
