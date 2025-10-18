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

class ClientProductDetailContent extends StatelessWidget {
  final Product? product;
  final ClientProductDetailBloc? bloc;
  final ClientProductDetailState state;

  const ClientProductDetailContent(this.bloc, this.state, this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // 🔹 fondo plano, sin degradado
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // 🖼 Imagen principal del producto
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ImageSlideshow(
                  width: size.width * 0.9,
                  height: 340,
                  initialPage: 0,
                  indicatorColor: AppTheme.primaryColor,
                  indicatorBackgroundColor: Colors.grey.shade300,
                  children: [
                    _productImage(product?.image1),
                    _productImage(product?.image2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Tarjeta de información flotante
            Container(
              width: size.width * 0.95,
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔸 Nombre del producto
                  Text(
                    product?.name ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔸 Descripción
                  Text(
                    product?.description ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔸 Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product?.price.toStringAsFixed(2) ?? ''}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 🔹 Controles y botón agregar
                  _actionsShoppingBag(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🖼 Widget para imagen del producto
  Widget _productImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/img/no-image.png',
        image: imageUrl,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset('assets/img/no-image.png', fit: BoxFit.cover);
    }
  }

  // 🛒 Sección: cantidad + botón agregar
  Widget _actionsShoppingBag(BuildContext context) {
    return Row(
      children: [
        // 🔘 Selector cantidad
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              _iconButton(CupertinoIcons.minus_circle_fill, () => bloc?.add(SubtractItem())),
              const SizedBox(width: 15),
              Text(
                state.quantity.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 15),
              _iconButton(CupertinoIcons.add_circled_solid, () => bloc?.add(AddItem())),
            ],
          ),
        ),

        const Spacer(),

        // 🛒 Botón agregar con degradado elegante
        GestureDetector(
          onTap: () async {
            await AlertHelper.showAlertDialog(
              context: context,
              title: "¡Producto agregado!",
              message: "Se agregó a la bolsa de compras correctamente.",
              isSuccess: true,
            );
            bloc?.add(AddProductToShoppingBag(product: product!));
          },
          child: Container(
            width: 160,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  Colors.orangeAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.cart_fill_badge_plus,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Agregar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Botón redondo Cupertino
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 28),
      ),
    );
  }
}
