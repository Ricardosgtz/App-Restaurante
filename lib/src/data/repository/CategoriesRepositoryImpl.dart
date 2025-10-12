import 'package:flutter_application_1/src/data/dataSource/remote/services/CategoriesService.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/repository/CategoriesRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesService categoriesService;

  CategoriesRepositoryImpl(this.categoriesService);

  @override
  Future<Resource<List<Category>>> getCategories() {
    return categoriesService.getCategories();
  }

}
