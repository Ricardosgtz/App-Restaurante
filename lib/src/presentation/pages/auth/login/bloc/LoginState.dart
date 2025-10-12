import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';

class LoginState extends Equatable {
  final BlocFormItem email;
  final BlocFormItem password;
  final Resource? response; //estado de la respuesta
  final GlobalKey<FormState>? formkey;

  const LoginState({
    this.email = const BlocFormItem(error: 'Ingrega el email'),
    this.password = const BlocFormItem(error: 'Ingrega el password'),
    this.formkey,
    this.response
  });

  LoginState copywith({
    BlocFormItem? email,
    BlocFormItem? password,
    Resource? response,
    GlobalKey<FormState>? formkey
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formkey: formkey,
      response: response
    );
  }

  @override
  List<Object?> get props => [email, password, response];
}
