import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';
import 'package:google_fonts/google_fonts.dart';

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
      onLongPress: () => _showDeleteConfirmation(context),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(
                  0.6,
                ),
                blurRadius: 10, // qué tan difusa
                spreadRadius: 3, // leve expansión
                offset: const Offset(0, 3),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _imageProduct(primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product?.name ?? 'Producto',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: primary,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _controlButton(
                                      icon: Icons.remove,
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
                                        widget.product?.quantity.toString() ??
                                            '0',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                    ),
                                    _controlButton(
                                      icon: Icons.add,
                                      onTap:
                                          () => widget.bloc?.add(
                                            AddItems(product: widget.product!),
                                          ),
                                      primary: primary,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    '\$${((widget.product?.price ?? 0) * (widget.product?.quantity ?? 0)).toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: primary,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageProduct(Color primary) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.25), primary.withOpacity(0.25)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            widget.product != null && widget.product!.image1!.isNotEmpty
                ? Image.network(
                  widget.product!.image1!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => _imageFallback(primary),
                )
                : _imageFallback(primary),
      ),
    );
  }

  Widget _imageFallback(Color primary) {
    return Container(
      child: Icon(Icons.photo, size: 45, color: Colors.grey),
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
      isDanger: true,
    );

    if (result == true && mounted) {
      widget.bloc?.add(RemoveItem(product: widget.product!));
    }
  }
}
