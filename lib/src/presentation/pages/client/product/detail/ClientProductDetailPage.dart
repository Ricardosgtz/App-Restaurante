import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/ClientProductDetailContent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailState.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeNavigationBar.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeState.dart';
// 🛍️ Importar el ClientShoppingBagBloc existente
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientProductDetailPage extends StatefulWidget {
  const ClientProductDetailPage({super.key});

  @override
  State<ClientProductDetailPage> createState() => _ClientProductDetailPageState();
}

class _ClientProductDetailPageState extends State<ClientProductDetailPage> {
  Product? product;
  ClientProductDetailBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc?.add(GetProducts(product: product!));
      // 🛍️ Cargar la bolsa al iniciar
      context.read<ClientShoppingBagBloc>().add(GetShoppingBag());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.add(ResetState());
  }

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)?.settings.arguments as Product;
    _bloc = BlocProvider.of<ClientProductDetailBloc>(context);

    final List<NavigationItem> navItems = [
      NavigationItem(icon: Icons.category_outlined, activeIcon: Icons.category, label: 'Categorías'),
      NavigationItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Mi Bolsa'),
      NavigationItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Mis Ordenes'),
      NavigationItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil'),
    ];

    return Scaffold(
      appBar: HomeAppBar(title: 'Detalle Del Producto'),
      body: BlocBuilder<ClientProductDetailBloc, ClientProductDetailState>(
        builder: (context, state) {
          return ClientProductDetailContent(_bloc, state, product);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // 🛍️ Escuchamos cambios en la bolsa
      bottomNavigationBar: BlocBuilder<ClientHomeBloc, ClientHomeState>(
        builder: (context, homeState) {
          return BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
            builder: (context, bagState) {
              return HomeNavigationBar(
                selectedIndex: homeState.pageIndex,
                items: navItems,
                shoppingBagCount: bagState.totalItems, // 👈 Contador dinámico
                onItemSelected: (index) {
                  context.read<ClientHomeBloc>().add(ChangeDrawerPage(pageIndex: index));
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              );
            },
          );
        },
      ),
    );
  }
}