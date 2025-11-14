import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';

void SelectOpcionImageDialog(
  BuildContext context,
  VoidCallback onGalleryPressed,
  VoidCallback onCameraPressed,
) {
  final primary = AppTheme.primaryColor;

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎨 Ícono decorativo superior
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary,
                        primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 📝 Título
                Text(
                  'Seleccionar Imagen',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Elige de dónde quieres obtener la foto',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                
                // 🎯 Botones de opciones
                Row(
                  children: [
                    Expanded(
                      child: _modernOptionButton(
                        icon: Icons.photo_library_rounded,
                        text: 'Galería',
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onGalleryPressed();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _modernOptionButton(
                        icon: Icons.camera_alt_rounded,
                        text: 'Cámara',
                        gradient: LinearGradient(
                          colors: [
                            primary,
                            primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onCameraPressed();
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // ❌ Botón cancelar
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// 🎨 Botón moderno con gradiente
Widget _modernOptionButton({
  required IconData icon,
  required String text,
  required Gradient gradient,
  required VoidCallback onPressed,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}