import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class ClientCategoryListState extends Equatable {
  final Resource? response;

  const ClientCategoryListState({this.response});

  ClientCategoryListState copyWith({Resource? response}) {
    return ClientCategoryListState(response: response);
  }

  @override
  List<Object?> get props => [response];
}
