import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart';

class DeleteItemShoppingBagUseCase {

  ShoppingBagRepository shoppingBagRepository;

  DeleteItemShoppingBagUseCase(this.shoppingBagRepository);

  run(Product product) => shoppingBagRepository.deleteItem(product);

}