import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';

abstract class ClientAddressListEvent extends Equatable {
  const ClientAddressListEvent();
  @override
  List<Object?> get props => [];
}

class GetUserAddress extends ClientAddressListEvent {
  final BuildContext context;
  const GetUserAddress(this.context);
}

class ChangeRadioValue extends ClientAddressListEvent {
  final int radioValue;
  final Address address;

  const ChangeRadioValue({required this.radioValue, required this.address});

  @override
  List<Object?> get props => [radioValue, address];
}

class SetAddressSession extends ClientAddressListEvent {
  final List<Address> addressList;

  const SetAddressSession({required this.addressList});

  @override
  List<Object?> get props => [addressList];
}

class DeleteAddress extends ClientAddressListEvent {
  final int id;
  final BuildContext context;
  const DeleteAddress({required this.id, required this.context});
  @override
  List<Object?> get props => [id];
}
