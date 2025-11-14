import 'dart:ui';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 35),
              //Encabezado del perfil
              _profileHeader(context, primary),
              const SizedBox(height: 20),

              // Contenedor de información
              _glassContainer(
                child: Column(
                  children: [
                    _infoItem(
                      CupertinoIcons.person_fill,
                      '${cliente?.name ?? ''} ${cliente?.lastname ?? ''}',
                      "Nombre de Usuario",
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _infoItem(
                      CupertinoIcons.mail_solid,
                      cliente?.email ?? '',
                      "Correo Electrónico",
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _infoItem(
                      CupertinoIcons.phone_solid,
                      cliente?.phone ?? '',
                      "Teléfono",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón editar perfil
              _editProfileButton(context, primary),
            ],
          ),
        ),
      ),
    );
  }

  // 🧊 Contenedor con efecto limpio y sombra suave
  Widget _glassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      //decoration: BoxDecoration(
      //  color: Colors.white,
      //  borderRadius: BorderRadius.circular(25),
      //  boxShadow: [
      //    BoxShadow(
      //      color: Colors.black.withOpacity(0.08),
      //      blurRadius: 12,
      //      offset: const Offset(0, 4),
      //    ),
      //  ],
      //),
      child: child,
    );
  }

  // 👤 Encabezado con imagen y nombre
  Widget _profileHeader(BuildContext context, Color primary) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 180,
              height: 180,
              child: ClipOval(
                child:
                    cliente != null && cliente!.image != null
                        ? Image.network(cliente!.image!, fit: BoxFit.cover)
                        : Image.asset(
                          'assets/img/no-perfil.jpg',
                          fit: BoxFit.cover,
                        ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '${cliente?.name ?? ''} ${cliente?.lastname ?? ''}',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          cliente?.email ?? '',
          style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }

  // 🔹 Item de información con ícono + texto
  Widget _infoItem(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 22),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Sin información',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Botón moderno para editar perfil
  Widget _editProfileButton(BuildContext context, Color primary) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        elevation: 6,
        shadowColor: primary.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        Navigator.pushNamed(context, 'profile/update', arguments: cliente);
      },
      child: Text(
        "Editar Perfil",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
