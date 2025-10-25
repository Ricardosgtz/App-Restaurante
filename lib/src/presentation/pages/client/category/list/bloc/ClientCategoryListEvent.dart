import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class ClientCategoryListEvent extends Equatable {
  const ClientCategoryListEvent();
  @override
  List<Object?> get props => [];
}

class GetCategories extends ClientCategoryListEvent {
  final BuildContext context;

  const GetCategories(this.context);

  @override
  List<Object?> get props => [context];
}

