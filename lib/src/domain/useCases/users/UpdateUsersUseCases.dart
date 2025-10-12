import 'dart:io';

import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart';

class UpdateUsersUseCases {

  UsersRepository usersRepository;
  UpdateUsersUseCases(this.usersRepository);

  run(int id, Cliente cliente, File? file) => usersRepository.update(id, cliente, file);

}