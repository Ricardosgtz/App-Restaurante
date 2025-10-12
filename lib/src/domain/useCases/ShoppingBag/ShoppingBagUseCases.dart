import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/AddShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/DeleteItemShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/DeleteShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/GetProductsShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/GetTotalShoppingBagUseCase.dart';

class ShoppingBagUseCases {

  AddShoppingBagUseCase add;
  GetProductsShoppingBagUseCase getProducts;
  DeleteItemShoppingBagUseCase deleteItem;
  DeleteShoppingBagUseCase deleteShoppingBag;
  GetTotalShoppingBagUseCase getTotal;

  ShoppingBagUseCases({
    required this.add,
    required this.getProducts,
    required this.deleteItem,
    required this.deleteShoppingBag,
    required this.getTotal
  });



}