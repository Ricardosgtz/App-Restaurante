import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfoContent extends StatelessWidget {
  final Cliente? cliente;

  const ProfileInfoContent(this.cliente, {super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 👤 Imagen perfil (estilo original)
              Stack(
                children: [
                  _imageProfile(primary),
                  Positioned(
                    bottom: 5,
                    right: 15,
                    child: _editButton(context, primary),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // 🏷️ Título principal
              Text(
                'Mi Perfil',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tu información personal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 📋 Tarjetas informativas
              _infoCard(
                CupertinoIcons.person_fill,
                '${cliente?.name ?? ''} ${cliente?.lastname ?? ''}',
                "Nombre de Usuario",
              ),
              _infoCard(
                CupertinoIcons.mail_solid,
                cliente?.email ?? '',
                "Correo Electrónico",
              ),
              _infoCard(
                CupertinoIcons.phone_solid,
                cliente?.phone ?? '',
                "Teléfono",
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// 👤 Imagen perfil (manteniendo tu estilo original)
  Widget _imageProfile(Color primary) {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primary, width: 5),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(
            child: cliente != null && cliente!.image != null
                ? Image.network(cliente!.image!, fit: BoxFit.cover)
                : Image.asset('assets/img/user_image.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  /// ✏️ Botón editar (estilo limpio y moderno)
  Widget _editButton(BuildContext context, Color primary) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'profile/update', arguments: cliente);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary,
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.pencil_outline,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  /// 💼 Tarjeta informativa refinada
  Widget _infoCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícono decorativo
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Texto principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title.isNotEmpty ? title : 'Sin información',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
