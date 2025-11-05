import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ProductsService.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/repository/ProductsRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsService productsService;

  ProductsRepositoryImpl(this.productsService);

  @override
  Future<Resource<List<Product>>> getProductsByCategory(
    int idCategory,
    BuildContext context, {
    bool forceRefresh = false,
  }) {
    return productsService.getProductByCategory(
      idCategory,
      context,
      forceRefresh: forceRefresh,
    );
  }
}
