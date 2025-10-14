import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

/// 🔹 Estado del Bloc de lista de órdenes del cliente
class ClientOrderListState extends Equatable {
  final Resource response;

  // ✅ Ya no asignamos valor por defecto aquí
  ClientOrderListState({Resource? response})
      : response = response ?? Initial(); // 👈 Asignación dentro del cuerpo

  ClientOrderListState copyWith({Resource? response}) {
    return ClientOrderListState(
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [response];
}
