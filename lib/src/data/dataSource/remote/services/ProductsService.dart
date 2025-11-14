import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/BaseService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class ProductsService extends BaseService {
  
  Future<Resource<List<Product>>> getProductByCategory(
    int idCategory,
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    try {
      final url = 'https://${Apiconfig.API_ECOMMERCE}/products/category/$idCategory';
      
      return await getCached<List<Product>>(
        url: url,
        context: context,
        onSuccess: (data) {
          List<Product> products = Product.fromJsonList(data);
          return products;
        },
        cacheDuration: CacheDuration.products,
        useCache: !forceRefresh,
        enableRetry: true,
      );
    } catch (e) {
      print('❌ Error getProductByCategory: $e');
      return Error(e.toString());
    }
  }

  /// 🔄 Refrescar productos
  /// Útil después de actualizar precios o disponibilidad
  Future<Resource<List<Product>>> refreshProducts(
    int idCategory,
    BuildContext context,
  ) async {
    invalidateCache('products');
    return getProductByCategory(idCategory, context, forceRefresh: true);
  }
}