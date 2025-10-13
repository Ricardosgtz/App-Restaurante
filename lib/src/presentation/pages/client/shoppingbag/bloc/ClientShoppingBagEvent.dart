import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';

abstract class ClientShoppingBagEvent extends Equatable {
  const ClientShoppingBagEvent();
  @override
  List<Object?> get props => [];
}

class GetShoppingBag extends ClientShoppingBagEvent {
  const GetShoppingBag();
}

class AddItem extends ClientShoppingBagEvent {
  final Product product;
  const AddItem({required this.product});
  @override
  List<Object?> get props => [product];
}

class SubtractItem extends ClientShoppingBagEvent {
  final Product product;
  const SubtractItem({required this.product});
  @override
  List<Object?> get props => [product];
}

class RemoveItem extends ClientShoppingBagEvent {
  final Product product;
  const RemoveItem({required this.product});
  @override
  List<Object?> get props => [product];
}

class GetTotal extends ClientShoppingBagEvent {
  const GetTotal();
}

class ClearShoppingBag extends ClientShoppingBagEvent {}

class ConfirmOrder extends ClientShoppingBagEvent {
  final int clientId;
  final int restaurantId;
  final int statusId;
  final int? addressId;
  final String orderType;
  final String? note;
  final List<Map<String, dynamic>> items;

  const ConfirmOrder({
    required this.clientId,
    required this.restaurantId,
    required this.statusId,
    this.addressId,
    required this.orderType,
    this.note,
    required this.items,
  });

  @override
  List<Object?> get props => [
    clientId,
    restaurantId,
    statusId,
    addressId,
    orderType,
    note,
    items,
  ];
}