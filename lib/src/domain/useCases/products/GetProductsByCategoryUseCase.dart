import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/ProductsRepository.dart';

class GetProductsByCategoryUseCase {

  ProductsRepository productsRepository;

  GetProductsByCategoryUseCase(this.productsRepository);

  run(int idCategory, BuildContext context) => productsRepository.getProductsByCategory(idCategory, context);

}