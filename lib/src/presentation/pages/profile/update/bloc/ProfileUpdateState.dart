import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';

class ProfileUpdateState extends Equatable {
  final int id;
  final BlocFormItem name;
  final BlocFormItem lastname;
  final BlocFormItem phone;
  final File? image;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const ProfileUpdateState({
    this.id = 0,
    this.name = const BlocFormItem(error: 'Nombre requerido'),
    this.lastname = const BlocFormItem(error: 'Apellido requerido'),
    this.phone = const BlocFormItem(error: 'Telefono requerido'),
    this.formKey,
    this.image,
    this.response,
  });

  toUser() => Cliente(
    id: id,
    name: name.value, 
    lastname: lastname.value, 
    phone: phone.value
  );

  ProfileUpdateState copyWith({
    int? id,
    BlocFormItem? name,
    BlocFormItem? lastname,
    BlocFormItem? phone,
    File? image,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return ProfileUpdateState(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      formKey: formKey,
      response: response,
    );
  }

  @override
  List<Object?> get props => [id, name, lastname, phone, image, response];
}
