import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/ClientProductListItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListState.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeNavigationBar.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeState.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientProductListPage extends StatefulWidget {
  const ClientProductListPage({super.key});

  @override
  State<ClientProductListPage> createState() => _ClientProductListPageState();
}

class _ClientProductListPageState extends State<ClientProductListPage> {
  ClientProductListBloc? _bloc;
  Category? category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (category != null) {
        _bloc?.add(GetProductsByCategory(
            idCategory: category!.id!, context: context));
      }
      context.read<ClientShoppingBagBloc>().add(GetShoppingBag());
    });
  }

  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context)?.settings.arguments as Category?;
    _bloc = BlocProvider.of<ClientProductListBloc>(context);

    final List<NavigationItem> navItems = [
      NavigationItem(
          icon: Icons.category_outlined,
          activeIcon: Icons.category,
          label: 'Categorías'),
      NavigationItem(
          icon: Icons.shopping_bag_outlined,
          activeIcon: Icons.shopping_bag,
          label: 'Mi Bolsa'),
      NavigationItem(
          icon: Icons.receipt_long_outlined,
          activeIcon: Icons.receipt_long,
          label: 'Mis Ordenes'),
      NavigationItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Perfil'),
    ];

    return Scaffold(
      appBar: HomeAppBar(title: category?.name ?? 'Productos'),
      body: BlocListener<ClientProductListBloc, ClientProductListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success && responseState.data is bool) {
            _bloc?.add(GetProductsByCategory(
                idCategory: category?.id ?? -1, context: context));
          } else if (responseState is Error) {
            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.redAccent,
            );
          }
        },
        child: BlocBuilder<ClientProductListBloc, ClientProductListState>(
          builder: (context, state) {
            final responseState = state.response;

            // 🟠 Pantalla de carga moderna
            if (responseState is Loading) {
              return _buildLoadingScreen();
            }

            // ✅ Cuando se cargan los productos
            if (responseState is Success) {
              List<Product> products = responseState.data as List<Product>;

              return RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  if (category == null) return;

                  final completer = Completer<void>();
                  StreamSubscription<ClientProductListState>? subscription;

                  subscription = _bloc?.stream.listen((state) {
                    final response = state.response;
                    if (response is Success || response is Error) {
                      subscription?.cancel();
                      completer.complete();
                    }
                  });

                  _bloc?.add(RefreshProducts(
                      idCategory: category!.id!, context: context));
                  await completer.future;

                  if (mounted && _bloc?.state.response is Success) {
                    Fluttertoast.showToast(
                      msg: "Productos actualizados",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  }
                },
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay productos disponibles',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ClientProductListItem(_bloc, products[index]);
                        },
                      ),
              );
            }

            // Estado inicial o desconocido
            return _buildLoadingScreen();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BlocBuilder<ClientHomeBloc, ClientHomeState>(
        builder: (context, homeState) {
          return BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
            builder: (context, bagState) {
              return HomeNavigationBar(
                selectedIndex: homeState.pageIndex,
                items: navItems,
                shoppingBagCount: bagState.totalItems,
                onItemSelected: (index) {
                  context
                      .read<ClientHomeBloc>()
                      .add(ChangeDrawerPage(pageIndex: index));
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              );
            },
          );
        },
      ),
    );
  }

  /// 🧡 Pantalla de carga con animación y texto moderno
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitThreeBounce(
              color: Colors.orange,
              size: 35,
              duration: Duration(milliseconds: 1200),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando productos...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
