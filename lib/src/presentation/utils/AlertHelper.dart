import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertHelper {
  /// Muestra un AlertDialog de éxito o error
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess,
    bool barrierDismissible = false, // opcional
    VoidCallback? onClose, // callback opcional al cerrar
  }) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                color: isSuccess ? Colors.green : Colors.redAccent,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: isSuccess ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onClose != null) onClose();
              },
              child: Text(
                isSuccess ? "Aceptar" : "Cerrar",
                style: GoogleFonts.poppins(
                  color: isSuccess ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
