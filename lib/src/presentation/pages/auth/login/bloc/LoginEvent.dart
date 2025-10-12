import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class InitEvent extends LoginEvent {
  const InitEvent();
}

class LoginFormReset extends LoginEvent {
  const LoginFormReset();
}

class LoginSaveUserSession extends LoginEvent {
  final AuthResponse authResponse;
  const LoginSaveUserSession({required this.authResponse});

  @override
  List<Object?> get props => [authResponse];
}

class EmailChanged extends LoginEvent {
  final BlocFormItem email;
  const EmailChanged({required this.email});
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final BlocFormItem password;
  const PasswordChanged({required this.password});
  @override
  List<Object?> get props => [password];
}

class LoginSubmit extends LoginEvent {
  const LoginSubmit();
}
