import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget que representa un item individual del pedido
/// Muestra: imagen, nombre, cantidad y precio del producto
class ClientOrderDetailItem extends StatelessWidget {
  final OrderDetail detail;

  const ClientOrderDetailItem({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: _buildCardDecoration(),
      child: Row(
        children: [
          _buildProductImage(),
          const SizedBox(width: 16),
          Expanded(
            child: _buildProductInfo(),
          ),
          const SizedBox(width: 12),
          _buildPriceSection(),
        ],
      ),
    );
  }

  /// Decoración de la tarjeta del producto
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Imagen del producto con bordes redondeados y manejo de errores
  Widget _buildProductImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/img/no-image.png',
          image: detail.product.image1 ?? '',
          width: 75,
          height: 75,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 400),
          imageErrorBuilder: (context, error, stackTrace) => Container(
            width: 75,
            height: 75,
            color: Colors.grey[100],
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey[400],
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  /// Información del producto: nombre y cantidad
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.product.name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildQuantityBadge(),
      ],
    );
  }

  /// Badge con la cantidad del producto
  Widget _buildQuantityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[100]!, Colors.orange[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(
          //  Icons.shopping_basket_rounded,
          //  size: 14,
          //  color: Colors.orange[800],
          //),
          const SizedBox(width: 5),
          Text(
            'Cantidad:',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${detail.quantity}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.orange[900],
            ),
          ),
        ],
      ),
    );
  }

  /// Sección de precios: precio unitario y subtotal
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUnitPrice(),
        const SizedBox(height: 8),
        _buildSubtotal(),
      ],
    );
  }

  /// Precio unitario
  Widget _buildUnitPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_money_rounded,
            size: 14,
            color: Colors.grey[600],
          ),
          Text(
            '${detail.unitPrice}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  /// Subtotal destacado
  Widget _buildSubtotal() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[100]!, Colors.green[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.green[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Colors.green[700],
          ),
          const SizedBox(width: 4),
          Text(
            '\$${detail.subtotal.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: Colors.green[800],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}