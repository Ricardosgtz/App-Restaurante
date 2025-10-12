import 'dart:io';

import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class UsersRepository {

  Future<Resource<Cliente>> update(int id, Cliente cliente, File? file);

}