import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class ProductsRepository {
  Future<Resource<List<Product>>> getProductsByCategory(int idCategory);
}
