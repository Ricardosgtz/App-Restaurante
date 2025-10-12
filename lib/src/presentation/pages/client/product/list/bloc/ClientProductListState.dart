
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class ClientProductListState extends Equatable {

  final Resource? response;

  const ClientProductListState({this.response});

  ClientProductListState copyWith({
    Resource? response
  }) {
    return ClientProductListState(response: response);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [response];

}