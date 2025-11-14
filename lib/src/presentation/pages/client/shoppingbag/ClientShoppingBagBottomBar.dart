import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientShoppingBagBottomBar extends StatelessWidget {
  final ClientShoppingBagState state;
  final String selectedOrderType;
  final int? selectedAddressId;
  final VoidCallback onConfirmOrder;

  const ClientShoppingBagBottomBar(
    this.state, {
    required this.selectedOrderType,
    this.selectedAddressId,
    required this.onConfirmOrder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Container(
      //color: Colors.transparent, //Fondo transparente
      child: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, //Solo la píldora blanca
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: primary, //Borde anaranjado
              width: 1.5, // Grosor del borde
            ),
          ),
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Row(
              children: [
                //Total de la orden
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total a pagar',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${state.total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                //Botón confirmar con estilo brillante
                ElevatedButton(
                  onPressed: onConfirmOrder,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return primary.withOpacity(0.85);
                      }
                      return primary;
                    }),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ordenar',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
