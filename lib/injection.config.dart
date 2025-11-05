// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart'
    as _i785;
import 'package:flutter_application_1/src/data/dataSource/remote/services/AddressServices.dart'
    as _i437;
import 'package:flutter_application_1/src/data/dataSource/remote/services/AuthService.dart'
    as _i301;
import 'package:flutter_application_1/src/data/dataSource/remote/services/CategoriesService.dart'
    as _i851;
import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart'
    as _i876;
import 'package:flutter_application_1/src/data/dataSource/remote/services/PaymentsService.dart'
    as _i50;
import 'package:flutter_application_1/src/data/dataSource/remote/services/ProductsService.dart'
    as _i832;
import 'package:flutter_application_1/src/data/dataSource/remote/services/UsersService.dart'
    as _i994;
import 'package:flutter_application_1/src/data/repository/AuthRepositoryImpl.dart'
    as _i535;
import 'package:flutter_application_1/src/di/AppModule.dart' as _i903;
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart'
    as _i74;
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart'
    as _i200;
import 'package:flutter_application_1/src/domain/repository/CategoriesRepository.dart'
    as _i583;
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart'
    as _i780;
import 'package:flutter_application_1/src/domain/repository/PaymentsRepository.dart'
    as _i918;
import 'package:flutter_application_1/src/domain/repository/ProductsRepository.dart'
    as _i305;
import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart'
    as _i263;
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart'
    as _i860;
import 'package:flutter_application_1/src/domain/useCases/address/AddressUseCases.dart'
    as _i304;
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart'
    as _i284;
import 'package:flutter_application_1/src/domain/useCases/categories/CategoriesUseCases.dart'
    as _i1053;
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart'
    as _i977;
import 'package:flutter_application_1/src/domain/useCases/payments/PaymentsUseCases.dart'
    as _i299;
import 'package:flutter_application_1/src/domain/useCases/products/ProductsUseCases.dart'
    as _i441;
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/ShoppingBagUseCases.dart'
    as _i932;
import 'package:flutter_application_1/src/domain/useCases/users/UsersUseCases.dart'
    as _i548;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i301.AuthService>(() => appModule.authService);
    gh.factoryAsync<String>(() => appModule.token);
    gh.factory<_i994.UsersService>(() => appModule.usersService);
    gh.factory<_i851.CategoriesService>(() => appModule.categoriesService);
    gh.factory<_i832.ProductsService>(() => appModule.productsService);
    gh.factory<_i437.AddressServices>(() => appModule.addressService);
    gh.factory<_i876.OrdersService>(() => appModule.ordersService);
    gh.factory<_i785.SharedPref>(() => appModule.sharedPref);
    gh.factory<_i200.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i860.UsersRepository>(() => appModule.usersRepository);
    gh.factory<_i583.CategoriesRepository>(
      () => appModule.categoriesRepository,
    );
    gh.factory<_i305.ProductsRepository>(() => appModule.productsRepository);
    gh.factory<_i263.ShoppingBagRepository>(
      () => appModule.shoppingBagRepository,
    );
    gh.factory<_i74.AddressRepository>(() => appModule.addressRepository);
    gh.factory<_i780.OrdersRepository>(() => appModule.ordersRepository);
    gh.factory<_i50.PaymentsService>(() => appModule.paymentsService);
    gh.factory<_i918.PaymentsRepository>(() => appModule.paymentsRepository);
    gh.factory<_i284.AuthUseCases>(() => appModule.authUserCases);
    gh.factory<_i548.UsersUseCases>(() => appModule.usersUseCases);
    gh.factory<_i1053.CategoriesUseCases>(() => appModule.categoriesUseCases);
    gh.factory<_i441.ProductsUseCases>(() => appModule.productsUseCases);
    gh.factory<_i932.ShoppingBagUseCases>(() => appModule.shoppingBagUseCases);
    gh.factory<_i304.AddressUseCases>(() => appModule.addressUseCases);
    gh.factory<_i977.OrdersUseCases>(() => appModule.ordersUseCases);
    gh.factory<_i299.PaymentsUseCases>(() => appModule.paymentsUseCases);
    gh.factory<_i535.AuthRepositoryImpl>(
      () => _i535.AuthRepositoryImpl(
        gh<_i301.AuthService>(),
        gh<_i785.SharedPref>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i903.AppModule {}
