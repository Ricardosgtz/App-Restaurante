import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/CategoriesRepository.dart';

class GetCategoriesUseCase {
  CategoriesRepository categoriesRepository;

  GetCategoriesUseCase(this.categoriesRepository);

  run(BuildContext context) => categoriesRepository.getCategories(context);
}
