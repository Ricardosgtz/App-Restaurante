
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class ClientAddressListState extends Equatable {
  final int? radioValue;
  final Resource? response;
  final Address? addressSelected;

  const ClientAddressListState({
    this.response,
    this.radioValue,
    this.addressSelected,
  });

  ClientAddressListState copyWith({
    Resource? response,
    int? radioValue,
    Address? addressSelected,
  }) {
    return ClientAddressListState(
      response: response ?? this.response,
      radioValue: radioValue ?? this.radioValue,
      addressSelected: addressSelected ?? this.addressSelected,
    );
  }

  @override
  List<Object?> get props => [response, radioValue, addressSelected];
}