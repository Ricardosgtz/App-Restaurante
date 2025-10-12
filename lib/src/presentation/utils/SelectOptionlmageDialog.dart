import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';

void SelectOpcionImageDialog(
  BuildContext context,
  VoidCallback onGalleryPressed,
  VoidCallback onCameraPressed,
) {
  showDialog(
    context: context,
    barrierDismissible: false, // 👈 Evita que se cierre al tocar fuera
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Seleccionar imagen',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _optionButton(
                    icon: Icons.photo_library_rounded,
                    text: 'Galería',
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                      onGalleryPressed();
                    },
                  ),
                  _optionButton(
                    icon: Icons.camera_alt_rounded,
                    text: 'Cámara',
                    color: AppTheme.primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                      onCameraPressed();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _optionButton({
  required IconData icon,
  required String text,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Column(
    children: [
      InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
