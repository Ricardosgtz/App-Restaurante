import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart';

class GetProductsShoppingBagUseCase {

  ShoppingBagRepository shoppingBagRepository;

  GetProductsShoppingBagUseCase(this.shoppingBagRepository);

  run() => shoppingBagRepository.getProducts();

}