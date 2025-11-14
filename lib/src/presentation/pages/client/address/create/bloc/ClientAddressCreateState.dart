import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';

class ClientAddressCreateState extends Equatable {
  final GlobalKey<FormState>? formKey;
  final BlocFormItem alias;
  final BlocFormItem address;
  final BlocFormItem reference;
  final Resource? response;
  final int idClient;

  const ClientAddressCreateState({
    this.alias = const BlocFormItem(error: 'Ingresa el alias'),
    this.address = const BlocFormItem(error: 'Ingresa la direccion'),
    this.reference = const BlocFormItem(error: 'Ingresa la referencia'),
    this.formKey,
    this.response,
    this.idClient = 0,
  });

  toAddress() => Address(
    alias: alias.value,
    address: address.value,
    reference: reference.value,
    idClient: idClient,
  );

  ClientAddressCreateState copyWith({
    BlocFormItem? alias,
    BlocFormItem? address,
    BlocFormItem? reference,
    GlobalKey<FormState>? formKey,
    Resource? response,
    int? idClient,
  }) {
    return ClientAddressCreateState(
      alias: alias ?? this.alias,
      address: address ?? this.address,
      reference: reference ?? this.reference,
      formKey: formKey,
      response: response,
      idClient: idClient ?? this.idClient,
    );
  }

  @override
  List<Object?> get props => [alias, address, reference, response, idClient];
}
