import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';

abstract class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateInitEvent extends ProfileUpdateEvent {
  final Cliente? cliente;
  const ProfileUpdateInitEvent({required this.cliente});

  @override
  List<Object?> get props => [cliente];
}

class ProfileUpdateUpdateUserSession extends ProfileUpdateEvent {
  final Cliente cliente;
  const ProfileUpdateUpdateUserSession({required this.cliente});
  @override
  List<Object?> get props => [cliente];
}

class ProfileUpdateNameChanged extends ProfileUpdateEvent {
  final BlocFormItem name;
  const ProfileUpdateNameChanged({required this.name});
  @override
  List<Object?> get props => [name];
}

class ProfileUpdateLastnameChanged extends ProfileUpdateEvent {
  final BlocFormItem lastname;
  const ProfileUpdateLastnameChanged({required this.lastname});
  @override
  List<Object?> get props => [lastname];
}

class ProfileUpdatePhoneChanged extends ProfileUpdateEvent {
  final BlocFormItem phone;
  const ProfileUpdatePhoneChanged({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class ProfileUpdateFormSubmit extends ProfileUpdateEvent {
  final BuildContext context;
  const ProfileUpdateFormSubmit(this.context);
}

class ProfileUpdatePickImage extends ProfileUpdateEvent {
  const ProfileUpdatePickImage();
}

class ProfileUpdateTakePhoto extends ProfileUpdateEvent {
  const ProfileUpdateTakePhoto();
}
