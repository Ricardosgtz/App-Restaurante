import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 AlertHelper - Estilo horizontal con ícono al lado
/// Diseño exacto del _showDeleteConfirmation del Design3
/// Características:
/// - Ícono circular pequeño al lado del título
/// - Layout horizontal
/// - Dos botones (Cancelar + Acción)
/// - Profesional y moderno

class AlertHelper {
  /// 🌟 Muestra un AlertDialog moderno
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess,
    bool barrierDismissible = false,
    VoidCallback? onClose,
  }) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _ModernAlertDialog(
          title: title,
          message: message,
          isSuccess: isSuccess,
          onClose: onClose,
        );
      },
    );
  }

  /// 🎯 Muestra un diálogo de confirmación
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Confirmar",
    String cancelText = "Cancelar",
    bool isDanger = false,
    
  }) async {
    if (!context.mounted) return null;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _ConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          isDanger: isDanger,
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Alert Dialog (Notificación)
// ═══════════════════════════════════════════════════════════

class _ModernAlertDialog extends StatefulWidget {
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
  State<_ModernAlertDialog> createState() => _ModernAlertDialogState();
}

class _ModernAlertDialogState extends State<_ModernAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.isSuccess 
        ? AppTheme.primaryColor 
        : Colors.red.shade600;
    
    final Color lightAccent = widget.isSuccess
        ? AppTheme.primaryColor.withOpacity(0.1)
        : Colors.red.shade50;

    final IconData icon = widget.isSuccess
        ? Icons.task_alt_rounded
        : CupertinoIcons.exclamationmark_triangle_fill;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        title: Row(
          children: [
            // Ícono circular pequeño
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Título
            Expanded(
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          widget.message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.onClose != null) widget.onClose!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: Text(
              widget.isSuccess ? 'Aceptar' : 'Entendido',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Confirmation Dialog (Confirmación)
// ═══════════════════════════════════════════════════════════

class _ConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDanger;

  const _ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDanger,
  });

  @override
  State<_ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<_ConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.isDanger 
        ? Colors.red.shade600
        : AppTheme.primaryColor;
    
    final Color lightAccent = widget.isDanger
        ? Colors.red.shade50
        : AppTheme.primaryColor.withOpacity(0.1);

    final IconData icon = widget.isDanger
        ? CupertinoIcons.exclamationmark_triangle_fill
        : CupertinoIcons.question_circle_fill;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        title: Row(
          children: [
            // Ícono circular
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Título
            Expanded(
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          widget.message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              widget.cancelText,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: Text(
              widget.confirmText,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}