import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomeAppBar({super.key, required this.title});

  void _showLogoutDialog(BuildContext context, ClientHomeBloc bloc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Cerrar Sesión',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          content: Text(
            '¿Seguro que deseas cerrar tu sesión?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Cerrar diálogo de confirmación
                Navigator.of(dialogContext).pop();
                
                // Ejecutar logout
                _performLogout(context, bloc);
              },
              icon: const Icon(Icons.logout, size: 18, color: Colors.white),
              label: Text(
                'Salir',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🔥 Método separado para manejar el logout
  void _performLogout(BuildContext context, ClientHomeBloc bloc) async {
    final primary = AppTheme.primaryColor;
    OverlayEntry? overlayEntry;
    
    // Crear overlay entry
    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFFFF3E0),
                Color(0xFFFFE0B2),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🍽️ Ícono circular
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.95),
                        primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                ),

                const SizedBox(height: 35),

                // ✨ Texto principal
                Text(
                  "Cerrando sesión...",
                  style: GoogleFonts.poppins(
                    color: Colors.orange.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                // 🟠 Loader animado
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 💬 Mensaje secundario
                Text(
                  "Hasta pronto...",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insertar el overlay
    Overlay.of(context).insert(overlayEntry);

    try {
      // Disparar evento de logout
      bloc.add(const Logout());

      // Esperar 2 segundos para mostrar la animación completa
      await Future.delayed(const Duration(milliseconds: 3000));

    } catch (e) {
      print('❌ Error durante logout: $e');
    } finally {
      // Remover el overlay
      overlayEntry.remove();
    }

    // Pequeña pausa después de remover el overlay
    await Future.delayed(const Duration(milliseconds: 100));

    // Navegar al login
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClientHomeBloc>(context);
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle ??
            GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showLogoutDialog(context, bloc),
          icon: const Icon(Icons.logout_rounded),
          color: Colors.white,
          tooltip: 'Cerrar Sesión',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}