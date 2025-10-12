import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';

class RegisterUseCase {
  AuthRepository repository;
  RegisterUseCase(this.repository);
  run(Cliente cliente) => repository.register(cliente);
}
