import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientShoppingBagItem extends StatelessWidget {
  final ClientShoppingBagBloc? bloc;
  final ClientShoppingBagState state;
  final Product? product;

  const ClientShoppingBagItem(this.bloc, this.state, this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🟢 Tarjeta del producto
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              color: primary.withOpacity(0.50),
              width: 1.9,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageProduct(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textProduct(primary),
                      const SizedBox(height: 3),
                      _textDescription(),
                      const SizedBox(height: 10),
                      _priceAndControls(primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 🗑️ Botón de eliminar flotante
        Positioned(
          top: 25,
          right: 25,
          child: GestureDetector(
            onTap: () => bloc?.add(RemoveItem(product: product!)),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.trash_fill,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🖼 Imagen con margen interno y 4 bordes redondeados
  Widget _imageProduct() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 95,
          height: 95,
          color: Colors.grey.shade100,
          child: product != null && product!.image1!.isNotEmpty
              ? FadeInImage.assetNetwork(
                  placeholder: 'assets/img/no-image.png',
                  image: product!.image1!,
                  fit: BoxFit.cover,
                )
              : Image.asset('assets/img/no-image.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  // 🍽 Nombre del producto
  Widget _textProduct(Color primary) {
    return Text(
      product?.name ?? 'Producto gourmet',
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // 🧾 Descripción
  Widget _textDescription() {
    return Text(
      product?.description ??
          'Platillo preparado con ingredientes frescos y de alta calidad.',
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.grey.shade600,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // 💵 Precio y controles
  Widget _priceAndControls(Color primary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Precio
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            '\$${(product!.price * product!.quantity!).toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Controles de cantidad
        Row(
          children: [
            _circleButton(
              icon: CupertinoIcons.minus,
              color: primary,
              onTap: () => bloc?.add(SubtractItem(product: product!)),
            ),
            const SizedBox(width: 10),
            Text(
              product?.quantity.toString() ?? '0',
              style: GoogleFonts.poppins(
                fontSize: 15.5,
                color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            _circleButton(
              icon: CupertinoIcons.add,
              color: primary,
              onTap: () => bloc?.add(AddItem(product: product!)),
            ),
          ],
        ),
      ],
    );
  }

  // 🔘 Botón circular elegante
  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.6), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
