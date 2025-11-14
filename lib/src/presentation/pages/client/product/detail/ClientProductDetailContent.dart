import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/detail/bloc/ClientProductDetailState.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//Importar el ClientShoppingBagBloc para actualizar el contador
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';

class ClientProductDetailContent extends StatelessWidget {
  final Product? product;
  final ClientProductDetailBloc? bloc;
  final ClientProductDetailState state;

  const ClientProductDetailContent(
    this.bloc,
    this.state,
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Imagen principal con borde anaranjado y sombra suave
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.orangeAccent.withOpacity(
                    0.9,
                  ), // Borde anaranjado
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.25),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ImageSlideshow(
                  width: size.width * 0.9,
                  height: 340,
                  initialPage: 0,
                  indicatorColor: primary,
                  indicatorBackgroundColor: Colors.grey.shade300,
                  isLoop: true,
                  autoPlayInterval: 0, // 🔹 No reproduce automáticamente
                  children: [
                    _productImage(product?.image1),
                    _productImage(product?.image2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tarjeta de detalle limpia
            Container(
              width: size.width * 0.93,
              margin: const EdgeInsets.only(bottom: 40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Text(
                    product?.name ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descripción
                  Text(
                    product?.description ??
                        'Delicioso platillo preparado con ingredientes frescos.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product?.price.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Controles
                  _actionsShoppingBag(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Imagen del producto
  Widget _productImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Container(
        color: Colors.white,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/img/sin-imagen.jpg',
          image: imageUrl,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset('assets/img/sin-imagen.jpg', fit: BoxFit.cover);
    }
  }

  // Controles y botón agregar
  Widget _actionsShoppingBag(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Controles cantidad
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Row(
            children: [
              _iconButton(
                CupertinoIcons.minus,
                () => bloc?.add(SubtractItem()),
              ),
              const SizedBox(width: 20),
              Text(
                state.quantity.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(width: 20),
              _iconButton(CupertinoIcons.add, () => bloc?.add(AddItem())),
            ],
          ),
        ),

        // Botón agregar moderno
        GestureDetector(
          onTap: () => _handleAddToCart(context),
          child: Container(
            width: 140,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary.withOpacity(0.95), primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.cart_fill_badge_plus,
                  color: Colors.white,
                  size: 23,
                ),
                const SizedBox(width: 8),
                Text(
                  'Agregar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Manejador para agregar al carrito con confirmación
  Future<void> _handleAddToCart(BuildContext context) async {
    // Mostrar confirmación
    final result = await AlertHelper.showConfirmationDialog(
      context: context,
      title: "Agregar producto",
      message: "¿Deseas añadir este producto a tu bolsa?",
      confirmText: "Agregar",
      cancelText: "Cancelar",
    );

    // Solo si el usuario confirma
    if (result == true) {
      bloc?.add(AddProductToShoppingBag(product: product!));

      // Pequeña pausa para asegurar que se guarde
      await Future.delayed(const Duration(milliseconds: 300));

      // Actualiza la bolsa de compras
      if (context.mounted) {
        context.read<ClientShoppingBagBloc>().add(GetShoppingBag());
      }
    }
  }

  //Botón de ícono minimalista
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    final primary = AppTheme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: primary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: primary, size: 22),
      ),
    );
  }
}
