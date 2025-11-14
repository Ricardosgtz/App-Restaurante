import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';

class ProfileInfoState extends Equatable {
  final Cliente? cliente;

  const ProfileInfoState({this.cliente});

  ProfileInfoState copywith({Cliente? cliente}) {
    return ProfileInfoState(cliente: cliente);
  }

  @override
  List<Object?> get props => [cliente];
}
