import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';

class LogoutUseCase {
  AuthRepository repository;
  LogoutUseCase(this.repository);

  run() => repository.logout();
}
