import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart';

class UpdateUsersUseCases {

  UsersRepository usersRepository;
  UpdateUsersUseCases(this.usersRepository);

  run(int id, Cliente cliente, File? file, BuildContext context) => usersRepository.update(id, cliente, file, context);

}