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
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.grey.shade300, // <-- borde gris
          width: 1.2,
        ), // grosor del borde
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 10,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _imageProduct(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textProduct(),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_textPrice(), _deleteButton(context)],
                ),
                const SizedBox(height: 12),
                _actionsShoppingBag(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Imagen del producto
  Widget _imageProduct() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child:
          product != null && product!.image1!.isNotEmpty
              ? FadeInImage.assetNetwork(
                placeholder: 'assets/img/no-image.png',
                image: product!.image1!,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
                fadeInDuration: const Duration(milliseconds: 400),
              )
              : Image.asset(
                'assets/img/no-image.png',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
    );
  }

  // 🔹 Nombre del producto
  Widget _textProduct() {
    return Text(
      product?.name ?? 'Producto',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // 🔹 Precio total del producto
  Widget _textPrice() {
    return product != null
        ? Text(
          '\$${(product!.price * product!.quantity!).toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        )
        : const SizedBox();
  }

  // 🔹 Botón eliminar
  Widget _deleteButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => bloc?.add(RemoveItem(product: product!)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade100.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(CupertinoIcons.trash, color: Colors.red, size: 18),
      ),
    );
  }

  // 🔹 Controles de cantidad (idéntico al detalle del producto)
  Widget _actionsShoppingBag(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(
            CupertinoIcons.minus_circle_fill,
            () => bloc?.add(SubtractItem(product: product!)),
          ),
          const SizedBox(width: 15),
          Text(
            product?.quantity.toString() ?? '0',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 15),
          _iconButton(
            CupertinoIcons.add_circled_solid,
            () => bloc?.add(AddItem(product: product!)),
          ),
        ],
      ),
    );
  }

  // 🔹 Botones icónicos de + y -
  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: AppTheme.primaryColor),
      ),
    );
  }
}
