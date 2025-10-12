import 'dart:io';

import 'package:flutter_application_1/src/data/dataSource/remote/services/UsersService.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class UsersRepositoryImpl implements UsersRepository {

  UsersService usersService;

  UsersRepositoryImpl(this.usersService);

  @override
  Future<Resource<Cliente>> update(int id, Cliente cliente, File? image) {
    if (image == null) {
      return usersService.update(id, cliente);
    }
    else {
      return usersService.updateImage(id, cliente, image);
    }
  }


}