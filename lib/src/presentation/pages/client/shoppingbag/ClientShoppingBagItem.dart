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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _imageProduct(), // ✅ Imagen con los 4 bordes redondeados y margen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textProduct(),
                  const SizedBox(height: 8),
                  _textDescription(),
                  const SizedBox(height: 10),
                  _priceAndControls(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🍷 Imagen del producto con borde redondeado y margen interno
  Widget _imageProduct() {
    return Container(
      margin: const EdgeInsets.all(10), // 🔹 margen entre la imagen y la tarjeta
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18), // 🔹 redondea las 4 esquinas
        child: Container(
          width: 95,
          height: 95,
          color: Colors.grey[100],
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

  // ✨ Nombre del producto elegante
  Widget _textProduct() {
    return Text(
      product?.name ?? 'Producto gourmet',
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
        letterSpacing: 0.3,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // 🍴 Descripción ligera
  Widget _textDescription() {
    return Text(
      product?.description ?? 'Platillo preparado con ingredientes frescos.',
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.grey.shade600,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // 💰 Precio y controles
  Widget _priceAndControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Precio
        Text(
          '\$${(product!.price * product!.quantity!).toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),

        // Controles + / - / Eliminar
        Row(
          children: [
            _circleButton(
              icon: CupertinoIcons.minus,
              color: AppTheme.primaryColor,
              onTap: () => bloc?.add(SubtractItem(product: product!)),
            ),
            const SizedBox(width: 12.5),
            Text(
              product?.quantity.toString() ?? '0',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12.5),
            _circleButton(
              icon: CupertinoIcons.add,
              color: AppTheme.primaryColor,
              onTap: () => bloc?.add(AddItem(product: product!)),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () => bloc?.add(RemoveItem(product: product!)),
              child: Icon(
                CupertinoIcons.trash,
                color: Colors.redAccent.shade200,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🔘 Botón circular minimalista
  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
