import 'package:equatable/equatable.dart';

/// 🔹 Eventos para la lista de productos del cliente
abstract class ClientProductListEvent extends Equatable {
  const ClientProductListEvent();

  @override
  List<Object?> get props => [];
}

/// ✅ Obtener los productos según la categoría
class GetProductsByCategory extends ClientProductListEvent {
  final int idCategory;

  const GetProductsByCategory({required this.idCategory});

  @override
  List<Object?> get props => [idCategory];
}

/// 🔄 Refrescar los productos de una categoría sin mostrar loading completo
class RefreshProducts extends ClientProductListEvent {
  final int idCategory;

  const RefreshProducts({required this.idCategory});

  @override
  List<Object?> get props => [idCategory];
}
