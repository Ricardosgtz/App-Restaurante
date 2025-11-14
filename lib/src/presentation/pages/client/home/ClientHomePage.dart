import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/ClientCategoryListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/ClientOrderListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/ClientShoppingBagPage.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/ProfileInfoPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeState.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeNavigationBar.dart';
import 'package:flutter_application_1/main.dart';
// Importar el ClientShoppingBagBloc
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar los productos de la bolsa
      context.read<ClientShoppingBagBloc>().add(GetShoppingBag());
      // Resetear el estado de logout al iniciar
      context.read<ClientHomeBloc>().add(const ResetLogoutState());
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      ClientCategoryListPage(),
      ClientShoppingBagPage(),
      ClientOrderListPage(),
      ProfileInfoPage(),
    ];

    final List<String> pageTitles = [
      'Categorías',
      'Bolsa De Compras',
      'Mis Ordenes',
      'Perfil de Usuario',
    ];

    final List<NavigationItem> navItems = [
      NavigationItem(
        icon: Icons.category_outlined,
        activeIcon: Icons.category,
        label: 'Categorías',
      ),
      NavigationItem(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: 'Mi Bolsa',
      ),
      NavigationItem(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Mis Ordenes',
      ),
      NavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Perfil',
      ),
    ];

    return BlocListener<ClientHomeBloc, ClientHomeState>(
      listenWhen:
          (previous, current) => current.isLoggedOut != previous.isLoggedOut,
      listener: (context, state) async {
        if (state.isLoggedOut) {
          // Esperar para que se vea la animación de loading
          await Future.delayed(const Duration(milliseconds: 1500));
          // Verificar que el contexto sigue montado
          if (!context.mounted) return;
          // AGREGAR ESTA LÍNEA - Reinicia la app completamente
          MyApp.restartApp(context);
          // Navegar al login eliminando todo el stack
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('login', (route) => false);
        }
      },
      child: BlocBuilder<ClientHomeBloc, ClientHomeState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: HomeAppBar(title: pageTitles[state.pageIndex]),
            body: pages[state.pageIndex],
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            //Usamos BlocBuilder para escuchar cambios en la bolsa
            bottomNavigationBar:
                BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
                  builder: (context, bagState) {
                    return HomeNavigationBar(
                      selectedIndex: state.pageIndex,
                      items: navItems,
                      shoppingBagCount:
                          bagState.totalItems,
                    );
                  },
                ),
          );
        },
      ),
    );
  }
}
