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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Imagen perfil con botón de editar
            Stack(
              children: [
                _imageProfile(),
                Positioned(
                  bottom: 5,
                  right: 15,
                  child: _editButton(context),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Info cards
            _infoCard(CupertinoIcons.person_solid,
                '${cliente?.name ?? ''} ${cliente?.lastname ?? ''}', "Nombre de Usuario"),
            _infoCard(CupertinoIcons.mail_solid, cliente?.email ?? '', "Correo Electrónico"),
            _infoCard(CupertinoIcons.phone_solid, cliente?.phone ?? '', "Teléfono"),

            // Spacer opcional para mantener todo centrado en pantallas grandes
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _imageProfile() {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primaryColor, width: 5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.15),
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

  Widget _editButton(BuildContext context) {
    return Material(
      color: AppTheme.primaryColor,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          Navigator.pushNamed(context, 'profile/update', arguments: cliente);
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(CupertinoIcons.pencil_outline, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Icon(icon, color: AppTheme.primaryColor, size: 26),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
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
