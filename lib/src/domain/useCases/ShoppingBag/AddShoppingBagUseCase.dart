import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart';

class AddShoppingBagUseCase {

  ShoppingBagRepository shoppingBagRepository;

  AddShoppingBagUseCase(this.shoppingBagRepository);

  run(Product product) => shoppingBagRepository.add(product);

}