import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/CategoriesService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/PaymentsService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ProductsService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/AddressServices.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/UsersService.dart';
import 'package:flutter_application_1/src/data/repository/AddressRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/AuthRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/AuthService.dart';
import 'package:flutter_application_1/src/data/repository/CategoriesRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/OrdersRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/PaymentsRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/ProductsRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/ShoppingBagRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/UsersRepositoryImpl.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';
import 'package:flutter_application_1/src/domain/repository/CategoriesRepository.dart';
import 'package:flutter_application_1/src/domain/repository/OrdersRepository.dart';
import 'package:flutter_application_1/src/domain/repository/PaymentsRepository.dart';
import 'package:flutter_application_1/src/domain/repository/ProductsRepository.dart';
import 'package:flutter_application_1/src/domain/repository/ShoppingBagRepository.dart';
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/AddShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/DeleteItemShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/DeleteShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/GetProductsShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/GetTotalShoppingBagUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/ShoppingBagUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/address/AddressUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/address/CreateAddressUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/address/DeleteAddressFromSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/address/DeleteAddressUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/address/GetAddressSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/address/GetUserAddressUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/address/SaveAddressInSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/RegisterUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/categories/GetCategoriesUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/CreateOrderUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/GetOrderDetailUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/GetOrdersByClientUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/payments/CreatePaymentUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/payments/PaymentsUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/products/GetProductsByCategoryUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/products/ProductsUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/users/UpdateUsersUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/users/UsersUseCases.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @injectable
  AuthService get authService => AuthService();

  @injectable
  Future<String> get token async {
    String token = "";
    final userSession = await sharedPref.read('cliente');
    if (userSession != null) {
      AuthResponse authResponse = AuthResponse.fromJson(userSession);
      token = authResponse.token;
    }
    return token;
  }

  @injectable
  UsersService get usersService => UsersService();
  @injectable
  CategoriesService get categoriesService => CategoriesService();
  @injectable
  ProductsService get productsService => ProductsService();
  @injectable
  AddressServices get addressService => AddressServices();
  @injectable
  OrdersService get ordersService => OrdersService();
  @injectable
  SharedPref get sharedPref => SharedPref(); //podremos ingestar el este objeto donde queramos
  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(authService, sharedPref);
  @injectable
  UsersRepository get usersRepository => UsersRepositoryImpl(usersService);
  @injectable
  CategoriesRepository get categoriesRepository => CategoriesRepositoryImpl(categoriesService);
  @injectable
  ProductsRepository get productsRepository => ProductsRepositoryImpl(productsService);
  @injectable
  ShoppingBagRepository get shoppingBagRepository => ShoppingBagRepositoryImpl(sharedPref);
  @injectable
  AddressRepository get addressRepository => AddressRepositoryImpl(addressService, sharedPref);
  @injectable
  OrdersRepository get ordersRepository => OrdersRepositoryImpl(ordersService);
  @injectable
  PaymentsService get paymentsService => PaymentsService();
  @injectable
  PaymentsRepository get paymentsRepository => PaymentsRepositoryImpl(paymentsService);


  @injectable
  AuthUseCases get authUserCases => AuthUseCases(
    login: LoginUseCase(authRepository),
    register: RegisterUseCase(authRepository),
    saveUserSession: SaveUserSessionUseCase(authRepository),
    getUserSession: GetUserSessionUseCase(authRepository),
    logout: LogoutUseCase(authRepository),
  );

  @injectable
  UsersUseCases get usersUseCases =>
      UsersUseCases(updateUsers: UpdateUsersUseCases(usersRepository));

  @injectable
  CategoriesUseCases get categoriesUseCases => CategoriesUseCases(
    getCategories: GetCategoriesUseCase(categoriesRepository),
  );

  @injectable
  ProductsUseCases get productsUseCases => ProductsUseCases(
    getProductsByCategory: GetProductsByCategoryUseCase(productsRepository),
  );

  @injectable
  ShoppingBagUseCases get shoppingBagUseCases => ShoppingBagUseCases(
    add: AddShoppingBagUseCase(shoppingBagRepository),
    getProducts: GetProductsShoppingBagUseCase(shoppingBagRepository),
    deleteItem: DeleteItemShoppingBagUseCase(shoppingBagRepository),
    deleteShoppingBag: DeleteShoppingBagUseCase(shoppingBagRepository),
    getTotal: GetTotalShoppingBagUseCase(shoppingBagRepository)
  );

    @injectable
  AddressUseCases get addressUseCases => AddressUseCases(
    create: CreateAddressUseCase(addressRepository),
    getUserAddress: GetUserAddressUseCase(addressRepository),
    saveAddressInSession: SaveAddressInSessionUseCase(addressRepository),
    getAddressSession: GetAddressSessionUseCase(addressRepository),
    delete: DeleteAddressUseCase(addressRepository),
    deleteFromSession: DeleteAddressFromSessionUseCase(addressRepository)
  );

  @injectable
  OrdersUseCases get ordersUseCases => OrdersUseCases(
    getOrdersByClient: GetOrdersByClientUseCase(ordersRepository),
    getOrderDetail: GetOrderDetailUseCase(ordersRepository),
    createOrder: CreateOrderUseCase(ordersRepository),
  );

  @injectable
  PaymentsUseCases get paymentsUseCases => PaymentsUseCases(
    createPayment: CreatePaymentUseCase(paymentsRepository),
  );

}
