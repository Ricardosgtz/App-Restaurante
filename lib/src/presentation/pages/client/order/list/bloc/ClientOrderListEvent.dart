import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class ClientOrderListEvent extends Equatable {
  const ClientOrderListEvent();

  @override
  List<Object?> get props => [];
}

class GetOrders extends ClientOrderListEvent {
  final BuildContext context;
  const GetOrders(this.context);
}

class RefreshOrders extends ClientOrderListEvent {
  final BuildContext context;
  const RefreshOrders(this.context);
}
