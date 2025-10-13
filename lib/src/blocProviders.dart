import 'package:flutter_application_1/injection.dart';
import 'package:flutter_application_1/src/domain/useCases/address/AddressUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/bloc/ClientCategoryListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/users/UsersUseCases.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListBloc.dart';
import 'package:flutter_application_1/src/domain/useCases/products/ProductsUseCases.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailBloc.dart';
import 'package:flutter_application_1/src/domain/useCases/ShoppingBag/ShoppingBagUseCases.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(create: (context) => LoginBloc(locator<AuthUseCases>())..add(InitEvent())),
  BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(locator<AuthUseCases>())..add(RegisterInitEvent())),
  BlocProvider<ProfileInfoBloc>(create: (context) => ProfileInfoBloc(locator<AuthUseCases>())..add(ProfileInfoGetUser())),
  BlocProvider<ProfileUpdateBloc>(create: (context) => ProfileUpdateBloc(locator<UsersUseCases>(), locator<AuthUseCases>())),
  BlocProvider<ClientHomeBloc>(create: (context) => ClientHomeBloc(locator<AuthUseCases>())),
  BlocProvider<ClientCategoryListBloc>(create: (context) => ClientCategoryListBloc(locator<CategoriesUseCases>())),
  BlocProvider<ClientProductListBloc>(create: (context) => ClientProductListBloc(locator<ProductsUseCases>())),
  BlocProvider<ClientProductDetailBloc>(create: (context) => ClientProductDetailBloc(locator<ShoppingBagUseCases>())),
  BlocProvider<ClientShoppingBagBloc>(create: (context) => ClientShoppingBagBloc(locator<ShoppingBagUseCases>(),locator<OrdersUseCases>(),)),
  BlocProvider<ClientAddressCreateBloc>(create: (context) => ClientAddressCreateBloc(locator<AddressUseCases>(), locator<AuthUseCases>())..add(ClientAddressCreateInitEvent())),
  BlocProvider<ClientAddressListBloc>(create: (context) => ClientAddressListBloc(locator<AddressUseCases>(), locator<AuthUseCases>())),
  BlocProvider<ClientShoppingBagBloc>(create: (context) => ClientShoppingBagBloc( locator<ShoppingBagUseCases>(),locator<OrdersUseCases>(),)),
];