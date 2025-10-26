import 'package:equatable/equatable.dart';

/// 🔹 Eventos del BLoC de la pantalla principal del cliente (Home)
abstract class ClientHomeEvent extends Equatable {
  const ClientHomeEvent();

  @override
  List<Object?> get props => [];
}

/// 📄 Evento para cambiar la página actual del Drawer o BottomNav
class ChangeDrawerPage extends ClientHomeEvent {
  final int pageIndex;

  const ChangeDrawerPage({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}

/// 🚪 Evento para cerrar sesión del usuario
class Logout extends ClientHomeEvent {
  const Logout();

  @override
  List<Object?> get props => [];
}
