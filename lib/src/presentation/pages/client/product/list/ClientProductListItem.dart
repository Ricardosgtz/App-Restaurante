import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListBloc.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';

class ClientProductListItem extends StatelessWidget {
  final ClientProductListBloc? bloc;
  final Product? product;

  const ClientProductListItem(this.bloc, this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = product?.available ?? true;

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          Navigator.pushNamed(
            context,
            'client/product/detail',
            arguments: product,
          );
        } else {
          // 🔹 Usamos AlertHelper en vez de Fluttertoast
          AlertHelper.showAlertDialog(
            context: context,
            title: 'Producto no disponible',
            message: 'Este producto no está disponible actualmente.',
            isSuccess: false,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isAvailable
              ? LinearGradient(
                  colors: [Colors.white, Colors.grey.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isAvailable ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👉 Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.name ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? AppTheme.primaryColor
                          : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product?.description ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isAvailable ? Colors.grey[700] : Colors.grey[500],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isAvailable) ...[
                    const SizedBox(height: 6),
                    Text(
                      'No disponible',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 👉 Imagen y precio
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Precio
                Text(
                  '\$${product?.price.toString() ?? ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? AppTheme.primaryColor : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                // Imagen del producto
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: product?.image1 != null && product!.image1!.isNotEmpty
                        ? ColorFiltered(
                            colorFilter: isAvailable
                                ? const ColorFilter.mode(
                                    Colors.transparent, BlendMode.multiply)
                                : const ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/img/no-image.png',
                              image: product!.image1!,
                              fit: BoxFit.cover,
                              width: 75,
                              height: 75,
                              fadeInDuration: const Duration(milliseconds: 400),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              color: Colors.white70,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
