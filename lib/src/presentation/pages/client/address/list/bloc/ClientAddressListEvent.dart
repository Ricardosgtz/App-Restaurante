
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';


abstract class ClientAddressListEvent extends Equatable {
  const ClientAddressListEvent();
  @override
  List<Object?> get props => [];
}

class GetUserAddress extends ClientAddressListEvent {
  const GetUserAddress();
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

  const SetAddressSession({ required this.addressList });

  @override
  List<Object?> get props => [addressList];
}

class DeleteAddress extends ClientAddressListEvent {
  final int id;
  const DeleteAddress({required this.id});
  @override
  List<Object?> get props => [id];
}