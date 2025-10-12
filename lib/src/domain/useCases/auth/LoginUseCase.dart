import 'package:flutter_application_1/src/data/repository/AuthRepositoryImpl.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';
import 'package:injectable/injectable.dart';

class LoginUseCase {
  AuthRepository repository;

  LoginUseCase(this.repository);

  run(String email, String password) => repository.login(email, password);
}
