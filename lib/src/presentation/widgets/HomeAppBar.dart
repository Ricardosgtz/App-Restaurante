import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomeAppBar({super.key, required this.title});

  // 🔸 Diálogo moderno para confirmar logout
  void _showLogoutDialog(BuildContext context, ClientHomeBloc bloc) {
    final primary = AppTheme.primaryColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 👤 Ícono circular naranja (más pequeño)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 32, // 👈 antes 40 → más compacto y elegante
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Seguro que deseas cerrar tu sesión?',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _showLoadingDialog(context);
                        bloc.add(const Logout());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Salir',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔸 Diálogo de carga elegante (ícono más pequeño)
  void _showLoadingDialog(BuildContext context) {
    final primary = AppTheme.primaryColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  const Color(0xFFFFF3E0),
                  const Color(0xFFFFE0B2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 40, // 👈 antes 50 → más proporcionado
                  ),
                ),

                const SizedBox(height: 26),

                Text(
                  "Cerrando sesión...",
                  style: GoogleFonts.poppins(
                    color: primary.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 22),

                SpinKitThreeBounce(
                  size: 26,
                  duration: const Duration(milliseconds: 1300),
                  itemBuilder: (context, index) {
                    final colors = [
                      primary,
                      primary.withOpacity(0.8),
                      Colors.orange.shade300,
                    ];
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors[index],
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 26),

                Text(
                  "Hasta pronto 👋",
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClientHomeBloc>(context);
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(
        color: Colors.white, // 👈 flecha blanca elegante
        size: 24,
      ),
      centerTitle: true,
      elevation: 6,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.95),
              const Color(0xFFFFA726),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        title,
        style:
            theme.appBarTheme.titleTextStyle ??
            GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.white,
            ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Container(
            width: 36, // 👈 define el ancho del círculo
            height: 36, // 👈 define el alto del círculo
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _showLogoutDialog(context, bloc),
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20, // 👈 más pequeño en el AppBar
              ),
              tooltip: 'Cerrar Sesión',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
