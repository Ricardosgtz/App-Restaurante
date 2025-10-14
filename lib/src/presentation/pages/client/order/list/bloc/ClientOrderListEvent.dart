import 'package:equatable/equatable.dart';

/// 🔹 Eventos para la lista de órdenes del cliente
abstract class ClientOrderListEvent extends Equatable {
  const ClientOrderListEvent();

  @override
  List<Object?> get props => [];
}

/// ✅ Obtener todas las órdenes del cliente autenticado
class GetOrders extends ClientOrderListEvent {
  const GetOrders();
}

/// 🔄 Refrescar las órdenes (sin mostrar loading completo)
class RefreshOrders extends ClientOrderListEvent {
  const RefreshOrders();
}
