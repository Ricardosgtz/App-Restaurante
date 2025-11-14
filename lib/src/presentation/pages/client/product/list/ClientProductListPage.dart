import 'dart:async';
import 'dart:ui';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';

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
        _bloc?.add(
          GetProductsByCategory(idCategory: category!.id!, context: context),
        );
      }
      context.read<ClientShoppingBagBloc>().add(GetShoppingBag());
      _checkAndShowHint(); //Mostrar aviso solo una vez
    });
  }

  ///Verifica si el aviso ya se mostró antes
  Future<void> _checkAndShowHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHint = prefs.getBool('hasSeenProductHint') ?? false;

    if (!hasSeenHint) {
      await Future.delayed(const Duration(milliseconds: 600)); // Pequeño delay
      _showHintDialog(context);
      prefs.setBool('hasSeenProductHint', true);
    }
  }

  /// 🧭 Diálogo elegante de aviso (versión productos)
void _showHintDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Solo se cierra con el botón
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 👁️ Ícono circular con degradado naranja
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.remove_red_eye_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),

              const SizedBox(height: 20),

              //Título principal
              Text(
                '¡Descubre los productos!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              // 📝 Texto explicativo
              Column(
                children: [
                  Text(
                    'Da clic en el botón “Ver Más” dentro de cada producto '
                    'para ver sus detalles, imagen y agregarlo a tu orden.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Desliza hacia abajo para actualizar la lista de productos.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Botón "Entendido"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Entendido',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context)?.settings.arguments as Category?;
    _bloc = BlocProvider.of<ClientProductListBloc>(context);

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(title: category?.name ?? 'Productos'),
      body: BlocListener<ClientProductListBloc, ClientProductListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success && responseState.data is bool) {
            _bloc?.add(
              GetProductsByCategory(
                idCategory: category?.id ?? -1,
                context: context,
              ),
            );
          }
        },
        child: BlocBuilder<ClientProductListBloc, ClientProductListState>(
          builder: (context, state) {
            final responseState = state.response;

            //Pantalla de carga moderna
            if (responseState is Loading) {
              return _buildLoadingScreen();
            }

            //Cuando hay un error (sin productos o error del servidor)
            if (responseState is Error) {
              return _buildEmptyState(responseState.message);
            }

            //Cuando se cargan los productos
            if (responseState is Success) {
              List<Product> products = responseState.data as List<Product>;

              //Si la lista está vacía
              if (products.isEmpty) {
                return _buildEmptyState(
                  'No hay productos disponibles en esta categoría',
                );
              }

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

                  _bloc?.add(
                    RefreshProducts(
                      idCategory: category!.id!,
                      context: context,
                    ),
                  );
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
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ClientProductListItem(_bloc, products[index]);
                  },
                ),
              );
            }

            //Estado inicial o desconocido
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
                  context.read<ClientHomeBloc>().add(
                    ChangeDrawerPage(pageIndex: index),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              );
            },
          );
        },
      ),
    );
  }

  ///Pantalla de carga con animación y texto moderno
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

  ///Pantalla cuando no hay productos o hay error
  Widget _buildEmptyState(String message) {
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

        _bloc?.add(
          RefreshProducts(idCategory: category!.id!, context: context),
        );
        await completer.future;
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Desliza hacia abajo para actualizar',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
