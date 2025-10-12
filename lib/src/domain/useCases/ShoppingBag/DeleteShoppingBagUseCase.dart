import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart';

class DeleteShoppingBagUseCase {
  ShoppingBagRepository shoppingBagRepository;

  DeleteShoppingBagUseCase(this.shoppingBagRepository);

  run() => shoppingBagRepository.deleteShoppingBag();
}