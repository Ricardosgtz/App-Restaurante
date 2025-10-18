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
    final primaryColor = AppTheme.primaryColor;

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          Navigator.pushNamed(context, 'client/product/detail',
              arguments: product);
        } else {
          AlertHelper.showAlertDialog(
            context: context,
            title: 'Producto no disponible',
            message: 'Este producto no está disponible actualmente.',
            isSuccess: false,
          );
        }
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isAvailable
                  ? [Colors.white, Colors.grey.shade100]
                  : [Colors.grey.shade200, Colors.grey.shade300],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            // ✅ Borde gris agregado
            border: Border.all(
              color: Colors.grey.withOpacity(0.25),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // 🖼 Imagen del producto con margen + overlay moderno
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: product?.image1 != null &&
                                product!.image1!.isNotEmpty
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
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.white70,
                                  size: 50,
                                ),
                              ),
                      ),

                      // 🔴 Overlay profesional para "Agotado"
                      if (!isAvailable)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Agotado',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 📝 Detalle del producto
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isAvailable
                              ? primaryColor
                              : Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product?.description ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.4)
                            )
                          ),
                          child: Text(
                            '\$${product?.price.toStringAsFixed(2) ?? '0.00'}',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
