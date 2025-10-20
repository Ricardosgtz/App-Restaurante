import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertHelper {
  /// 🌟 Muestra un AlertDialog moderno de éxito o error
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess,
    bool barrierDismissible = false,
    VoidCallback? onClose,
  }) async {
    if (!context.mounted) return;

    await showGeneralDialog(
      context: context,
      barrierLabel: "Alert",
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, animation, _, child) {
        final curvedValue = Curves.easeOutBack.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: _ModernAlertDialog(
              title: title,
              message: message,
              isSuccess: isSuccess,
              onClose: onClose,
            ),
          ),
        );
      },
    );
  }
}

class _ModernAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback? onClose;

  const _ModernAlertDialog({
    required this.title,
    required this.message,
    required this.isSuccess,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? Colors.green : Colors.redAccent;
    final icon = isSuccess
        ? CupertinoIcons.checkmark_seal_fill
        : CupertinoIcons.exclamationmark_triangle_fill;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 35, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.96),
                  Colors.grey.shade100.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Ícono
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                  ),
                  child: Icon(icon, color: color, size: 40),
                ),
                const SizedBox(height: 16),

                // 🔹 Título
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10),

                // 🔹 Mensaje
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Botón
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onClose != null) onClose!();
                    },
                    icon: Icon(
                      isSuccess
                          ? CupertinoIcons.checkmark_alt
                          : CupertinoIcons.xmark_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      isSuccess ? "Aceptar" : "Cerrar",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 18,
                      ),
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
