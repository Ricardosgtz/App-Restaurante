
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';

abstract class ClientAddressCreateEvent extends Equatable {
  const ClientAddressCreateEvent();
  @override
  List<Object?> get props => [];
}

class ClientAddressCreateInitEvent extends ClientAddressCreateEvent {
  const ClientAddressCreateInitEvent();
}

class AliasChanged extends ClientAddressCreateEvent {
  final BlocFormItem alias;
  const AliasChanged({ required this.alias });
  @override
  List<Object?> get props => [alias];
}

class AddressChanged extends ClientAddressCreateEvent {
  final BlocFormItem address;
  const AddressChanged({ required this.address });
  @override
  List<Object?> get props => [address];
}


class ReferenceChanged extends ClientAddressCreateEvent {
  final BlocFormItem reference;
  const ReferenceChanged({ required this.reference });
  @override
  List<Object?> get props => [reference];
}

class FormSubmit extends ClientAddressCreateEvent {
  final BuildContext context;

  FormSubmit(this.context);
}