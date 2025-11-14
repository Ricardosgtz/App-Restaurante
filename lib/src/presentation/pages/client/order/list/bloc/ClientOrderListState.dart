import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class ClientOrderListState extends Equatable {
  final Resource response;

  ClientOrderListState({Resource? response}) : response = response ?? Initial();

  ClientOrderListState copyWith({Resource? response}) {
    return ClientOrderListState(response: response ?? this.response);
  }

  @override
  List<Object?> get props => [response];
}
