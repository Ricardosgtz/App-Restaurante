import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 DISEÑO 3: CARD ELEVADA CON GLASSMORPHISM
/// Características:
/// - Efecto glassmorphism premium
/// - Diseño elevado con sombras profundas
/// - Controles grandes y táctiles
/// - Separación visual clara
/// - Botón eliminar flotante

class ClientShoppingBagItem extends StatefulWidget {
  final ClientShoppingBagBloc? bloc;
  final ClientShoppingBagState state;
  final Product? product;

  const ClientShoppingBagItem(this.bloc, this.state, this.product, {super.key});

  @override
  State<ClientShoppingBagItem> createState() => _ClientShoppingBagItemState();
}

class _ClientShoppingBagItemState extends State<ClientShoppingBagItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary.withOpacity(0.05), primary.withOpacity(0.02)],
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Imagen del producto
                          _imageProduct(primary),

                          const SizedBox(width: 16),

                          // Información
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nombre
                                Text(
                                  widget.product?.name ?? 'Producto',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade900,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 8),

                                // Precio unitario
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${widget.product?.price.toStringAsFixed(2) ?? '0.00'} por unidad',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Controles y total
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Controles cantidad
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _controlButton(
                                            icon: CupertinoIcons.minus,
                                            onTap:
                                                () => widget.bloc?.add(
                                                  SubtractItems(
                                                    product: widget.product!,
                                                  ),
                                                ),
                                            primary: primary,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                            ),
                                            child: Text(
                                              widget.product?.quantity
                                                      .toString() ??
                                                  '0',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey.shade900,
                                              ),
                                            ),
                                          ),
                                          _controlButton(
                                            icon: CupertinoIcons.add,
                                            onTap:
                                                () => widget.bloc?.add(
                                                  AddItems(
                                                    product: widget.product!,
                                                  ),
                                                ),
                                            primary: primary,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Precio total
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            primary,
                                            primary.withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primary.withOpacity(0.4),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '\$${((widget.product?.price ?? 0) * (widget.product?.quantity ?? 0)).toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
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

                    // Botón eliminar
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _showDeleteConfirmation(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.red.shade600,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            CupertinoIcons.trash_fill,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageProduct(Color primary) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.2), primary.withOpacity(0.1)],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
            widget.product != null && widget.product!.image1!.isNotEmpty
                ? Image.network(
                  widget.product!.image1!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primary.withOpacity(0.3),
                            primary.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 45,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    );
                  },
                )
                : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.3),
                        primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 45,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color primary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: primary.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: primary.withOpacity(0.1), blurRadius: 6),
          ],
        ),
        child: Icon(icon, size: 18, color: primary),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final result = await AlertHelper.showConfirmationDialog(
      context: context,
      title: "¿Eliminar producto?",
      message:
          '¿Deseas eliminar "${widget.product?.name ?? 'este producto'}" de tu carrito?',
      confirmText: "Eliminar",
      cancelText: "Cancelar",
      isDanger: true, // 🔴 activa el estilo rojo de alerta
    );

    if (result == true && mounted) {
      widget.bloc?.add(RemoveItem(product: widget.product!));
    }
  }
}
