import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart';

class GetTotalShoppingBagUseCase {

  ShoppingBagRepository shoppingBagRepository;

  GetTotalShoppingBagUseCase(this.shoppingBagRepository);

  run() => shoppingBagRepository.getTotal();

}