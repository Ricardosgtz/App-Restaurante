import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> run() async {
    await repository.logout();
  }
}
