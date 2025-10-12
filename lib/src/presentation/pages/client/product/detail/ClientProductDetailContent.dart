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
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Imagen con efecto Glass
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: ImageSlideshow(
                      width: size.width * 0.9,
                      height: 360,
                      initialPage: 0,
                      indicatorColor: AppTheme.primaryColor,
                      indicatorBackgroundColor: Colors.grey[300],
                      children: [
                        _productImage(product?.image1),
                        _productImage(product?.image2),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 🔹 Tarjeta de información
              Container(
                width: size.width * 0.94,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.name ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      product?.description ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product?.price.toString() ?? ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Controles de cantidad y botón
                    _actionsShoppingBag(context, textTheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  // 🔹 Sección de acciones
  Widget _actionsShoppingBag(BuildContext context, TextTheme textTheme) {
    return Row(
      children: [
        // 🔘 Selector cantidad
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
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

        // 🛒 Botón agregar con degradado
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
            width: 150,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.9),
                  Colors.orangeAccent.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.cart_fill_badge_plus, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Agregar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Botón redondo Cupertino para sumar/restar
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
              color: Colors.black.withOpacity(0.07),
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
