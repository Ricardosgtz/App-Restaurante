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
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientProductDetailPage extends StatefulWidget {
  const ClientProductDetailPage({super.key});

  @override
  State<ClientProductDetailPage> createState() =>
      _ClientProductDetailPageState();
}

class _ClientProductDetailPageState extends State<ClientProductDetailPage> {
  Product? product;
  ClientProductDetailBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc?.add(GetProducts(product: product!));
      context.read<ClientShoppingBagBloc>().add(GetShoppingBag());
      _checkAndShowHint(); // Muestra el aviso solo una vez
    });
  }

  /// Verifica si ya se mostró el aviso antes
  Future<void> _checkAndShowHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHint = prefs.getBool('hasSeenProductDetailHint') ?? false;

    if (!hasSeenHint) {
      await Future.delayed(const Duration(milliseconds: 500));
      _showHintDialog(context);
      prefs.setBool('hasSeenProductDetailHint', true);
    }
  }

  /// 🛒 Diálogo elegante informativo (versión productos favoritos)
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
                // 🛍️ Ícono circular con degradado naranja
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
                    Icons.shopping_cart_checkout_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                // 🧾 Título principal
                Text(
                  '¡Agrega tus favoritos!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // 📋 Texto explicativo
                Text(
                  'Aquí puedes ver los detalles del producto, ajustar la cantidad con los botones (– +) y agregarlo a tu orden con el botón “Agregar”.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ Botón "Entendido"
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
  void dispose() {
    super.dispose();
    _bloc?.add(ResetState());
  }

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)?.settings.arguments as Product;
    _bloc = BlocProvider.of<ClientProductDetailBloc>(context);

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
      appBar: HomeAppBar(title: 'Detalle del Producto'),
      body: BlocBuilder<ClientProductDetailBloc, ClientProductDetailState>(
        builder: (context, state) {
          return ClientProductDetailContent(_bloc, state, product);
        },
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
}
