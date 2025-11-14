import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListBloc.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';

class ClientProductListItem extends StatefulWidget {
  final ClientProductListBloc? bloc;
  final Product? product;

  const ClientProductListItem(this.bloc, this.product, {super.key});

  @override
  State<ClientProductListItem> createState() => _ClientProductListItemState();
}

class _ClientProductListItemState extends State<ClientProductListItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final bool isAvailable = product?.available ?? true;
    final primaryColor = AppTheme.primaryColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        // Solo muestra alerta si no está disponible, no navega
        if (!isAvailable) {
          AlertHelper.showAlertDialog(
            context: context,
            title: 'Producto no disponible',
            message: 'Este producto no está disponible actualmente.',
            isSuccess: false,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(
                0.6,
              ), // ✅ sombra gris clara
              blurRadius: 10, // qué tan difusa
              spreadRadius: 3, // leve expansión
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen cuadrada con bordes redondeados
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.25),
                        primaryColor.withOpacity(0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        (product?.image1 != null && product!.image1!.isNotEmpty)
                            ? Image.network(
                              product.image1!,
                              fit: BoxFit.cover,
                              color: isAvailable ? null : Colors.grey,
                              colorBlendMode:
                                  isAvailable ? null : BlendMode.saturation,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.photo,
                                  size: 50,
                                  color: Colors.white,
                                );
                              },
                            )
                            : Icon(Icons.photo, size: 50, color: Colors.grey),
                  ),
                ),

                // Indicador si no está disponible
                if (!isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product?.name ?? 'Sin nombre',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                isAvailable
                                    ? primaryColor
                                    : Colors.grey.shade500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Agotado',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Descripción
                  Text(
                    product?.description ?? 'Sin descripción',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    //maxLines: 2,
                    //overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Precio + Botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product?.price.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: isAvailable ? primaryColor : Colors.grey,
                        ),
                      ),
                      if (isAvailable)
                        GestureDetector(
                          onTap: () {
                            // Solo el botón navega al detalle
                            Navigator.pushNamed(
                              context,
                              'client/product/detail',
                              arguments: product,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _isPressed
                                      ? primaryColor.withOpacity(0.2)
                                      : primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ver Mas',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
