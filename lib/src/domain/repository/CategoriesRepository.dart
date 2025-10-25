import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class CategoriesRepository {

  Future<Resource<List<Category>>> getCategories(BuildContext context);
}
