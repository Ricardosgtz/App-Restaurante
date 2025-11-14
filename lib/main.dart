import 'package:flutter/material.dart';
import 'package:flutter_application_1/injection.dart';
import 'package:flutter_application_1/src/blocProviders.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/TokenHelper.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/ClientAddressCreatePage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/ClientAddressListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/ClientHomePage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/confirmation/ClientOrderConfirmationPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/detail/ClientOrderDetailPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/ClientOrderListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/ClientProductDetailPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/ClientProductListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/ClientShoppingBagPage.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/ProfileInfoPage.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/ProfileUpdatePage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await initializeDateFormatting('es_MX', null);

  final SharedPref sharedPref = SharedPref();
  final data = await sharedPref.read('cliente');

  Widget initialPage = LoginPage();

  if (data != null) {
    final authResponse = AuthResponse.fromJson(data);
    final tokenExpirado = TokenHelper.isTokenExpired(authResponse);

    if (!tokenExpirado) {
      initialPage = ClientHomePage();
    } else {
      await sharedPref.remove('cliente');
      initialPage = LoginPage();
    }
  }

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatefulWidget {
  final Widget initialPage;
  const MyApp({required this.initialPage, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }
}

class _MyAppState extends State<MyApp> {
  Key _key = UniqueKey();
  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: _key,
      providers: blocProviders,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: widget.initialPage,
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'profile/info': (BuildContext context) => ProfileInfoPage(),
          'profile/update': (BuildContext context) => ProfileUpdatePage(),
          'client/home': (BuildContext context) => ClientHomePage(),
          'client/product/list': (BuildContext context) => ClientProductListPage(),
          'client/product/detail': (BuildContext context) => ClientProductDetailPage(),
          'client/shopping_bag': (BuildContext context) => ClientShoppingBagPage(),
          'client/address/list': (BuildContext context) => ClientAddressListPage(),
          'client/address/create': (BuildContext context) => ClientAddressCreatePage(),
          'client/order/confirmation': (context) => const ClientOrderConfirmationPage(),
          'client/order/list': (BuildContext context) => const ClientOrderListPage(),
          'client/order/detail': (context) => const ClientOrderDetailPage(),
        },
      ),
    );
  }
}