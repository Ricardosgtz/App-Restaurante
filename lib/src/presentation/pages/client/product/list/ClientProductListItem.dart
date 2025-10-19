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
  double _scale = 1.0;
  double _shadowBlur = 8;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.97;
      _shadowBlur = 3;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
      _shadowBlur = 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final bool isAvailable = product?.available ?? true;
    final primaryColor = AppTheme.primaryColor;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
          _shadowBlur = 8;
        });
      },
      onTap: () {
        if (isAvailable) {
          Navigator.pushNamed(
            context,
            'client/product/detail',
            arguments: product,
          );
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
        scale: _scale,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: _shadowBlur,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAvailable
                    ? primaryColor.withOpacity(0.6)
                    : Colors.grey.shade600,
                width: 2,
              ),
              color: isAvailable
                  ? Colors.white
                  : Colors.grey.shade300.withOpacity(0.8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                // 🖼 Imagen del producto con margen interno
                Padding(
                  padding: const EdgeInsets.all(10.0), // 🔹 margen de separación
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // 🔹 4 bordes redondeados
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: (product?.image1 != null &&
                                product!.image1!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(product!.image1!),
                                fit: BoxFit.cover,
                                colorFilter: isAvailable
                                    ? null
                                    : const ColorFilter.mode(
                                        Colors.grey, BlendMode.saturation),
                              )
                            : null,
                        color: (product?.image1 == null ||
                                product!.image1!.isEmpty)
                            ? Colors.grey[200]
                            : null,
                      ),
                      child: (product?.image1 == null ||
                              product!.image1!.isEmpty)
                          ? const Icon(Icons.image,
                              color: Colors.white70, size: 50)
                          : null,
                    ),
                  ),
                ),

                // 🧾 Detalles del producto
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Nombre
                        Text(
                          product?.name ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isAvailable
                                ? primaryColor
                                : Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // 📝 Descripción
                        Text(
                          product?.description ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isAvailable
                                ? Colors.grey[700]
                                : Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // 💵 Precio
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: isAvailable
                                  ? LinearGradient(
                                      colors: [
                                        primaryColor,
                                        primaryColor.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.grey.shade500,
                                        Colors.grey.shade600,
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              '\$${product?.price.toStringAsFixed(2) ?? '0.00'}',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
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
      ),
    );
  }
}
