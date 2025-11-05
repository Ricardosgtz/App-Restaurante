// 📁 GetProductsByCategoryUseCase.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/ProductsRepository.dart';

class GetProductsByCategoryUseCase {
  final ProductsRepository productsRepository;

  GetProductsByCategoryUseCase(this.productsRepository);

  run({
    required int idCategory,
    required BuildContext context,
    bool forceRefresh = false,
  }) {
    return productsRepository.getProductsByCategory(
      idCategory,
      context,
      forceRefresh: forceRefresh,
    );
  }
}