import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/ClientCategoryListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/ClientOrderListPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/ClientShoppingBagPage.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/ProfileInfoPage.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeState.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeFAB.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      ClientCategoryListPage(),
      ClientShoppingBagPage(),
      ClientOrderListPage(),
      ProfileInfoPage(),
    ];

    final List<String> pageTitles = ['Categorías', 'Bolsa De Compras', 'Mis Ordenes', 'Perfil de Usuario'];

    final List<NavigationItem> navItems = [
      NavigationItem(icon: Icons.category_outlined, activeIcon: Icons.category, label: 'Categorías'),
      NavigationItem(icon: Icons.shopping_bag, activeIcon: Icons. shopping_bag_outlined, label: 'Mi Bolsa'),
      NavigationItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Mis Ordenes'),
      NavigationItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil'),
    ];

    return BlocBuilder<ClientHomeBloc, ClientHomeState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: HomeAppBar(title: pageTitles[state.pageIndex]),
          body: pages[state.pageIndex],
          //floatingActionButton: const HomeFAB(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: HomeNavigationBar(
            selectedIndex: state.pageIndex,
            items: navItems,
          ),
        );
      },
    );
  }
}