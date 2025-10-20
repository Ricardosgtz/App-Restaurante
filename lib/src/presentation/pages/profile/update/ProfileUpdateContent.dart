import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';
import 'package:flutter_application_1/src/presentation/utils/SelectOptionlmageDialog.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUpdateContent extends StatefulWidget {
  final ProfileUpdateBloc? bloc;
  final ProfileUpdateState state;
  final Cliente? cliente;

  const ProfileUpdateContent(this.bloc, this.state, this.cliente, {super.key});

  @override
  State<ProfileUpdateContent> createState() => _ProfileUpdateContentState();
}

class _ProfileUpdateContentState extends State<ProfileUpdateContent> {
  bool _showErrors = false;

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: widget.state.formKey,
        autovalidateMode:
            _showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              _headerSection(primary),
              const SizedBox(height: 35),
              _glassCardForm(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 🧑‍💼 Header con foto de perfil
  Widget _headerSection(Color primary) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primary, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.15),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: widget.state.image != null
                    ? Image.file(widget.state.image!, fit: BoxFit.cover)
                    : (widget.cliente?.image != null
                        ? Image.network(widget.cliente!.image!,
                            fit: BoxFit.cover)
                        : Image.asset('assets/img/user_image.png',
                            fit: BoxFit.cover)),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Material(
                color: primary,
                shape: const CircleBorder(),
                elevation: 6,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    SelectOpcionImageDialog(
                      context,
                      () => widget.bloc?.add(ProfileUpdatePickImage()),
                      () => widget.bloc?.add(ProfileUpdateTakePhoto()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      CupertinoIcons.camera_fill,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Editar perfil',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Actualiza tu información personal',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  /// 🧊 Tarjeta con los campos personalizados
  Widget _glassCardForm(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _textFieldName(),
              const SizedBox(height: 18),
              _textFieldLastname(),
              const SizedBox(height: 18),
              _textFieldPhone(),
              const SizedBox(height: 30),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 👤 Campo Nombre
  Widget _textFieldName() {
    return _buildInputContainer(
      icon: CupertinoIcons.person_fill,
      label: 'Nombre',
      initialValue: widget.cliente?.name ?? '',
      onChanged: (text) => widget.bloc
          ?.add(ProfileUpdateNameChanged(name: BlocFormItem(value: text))),
      validator: (value) =>
          (value == null || value.isEmpty) && _showErrors ? 'Ingresa el nombre' : null,
    );
  }

  /// 👤 Campo Apellido
  Widget _textFieldLastname() {
    return _buildInputContainer(
      icon: CupertinoIcons.person,
      label: 'Apellido',
      initialValue: widget.cliente?.lastname ?? '',
      onChanged: (text) => widget.bloc?.add(
          ProfileUpdateLastnameChanged(lastname: BlocFormItem(value: text))),
      validator: (value) => (value == null || value.isEmpty) && _showErrors
          ? 'Ingresa el apellido'
          : null,
    );
  }

  /// 📞 Campo Teléfono
  Widget _textFieldPhone() {
    return _buildInputContainer(
      icon: CupertinoIcons.phone_fill,
      label: 'Teléfono',
      initialValue: widget.cliente?.phone ?? '',
      onChanged: (text) => widget.bloc
          ?.add(ProfileUpdatePhoneChanged(phone: BlocFormItem(value: text))),
      validator: (value) => (value == null || value.isEmpty) && _showErrors
          ? 'Ingresa el teléfono'
          : null,
    );
  }

  /// 🔤 Contenedor de campo personalizado (copiado del formulario de dirección)
  Widget _buildInputContainer({
    required IconData icon,
    required String label,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    String initialValue = '',
  }) {
    final primary = AppTheme.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 14.5),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primary, size: 22),
          ),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 13.5,
            color: Colors.grey[700],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// 🧡 Botón tipo píldora
  Widget _saveButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _showErrors = true;
          });

          if (widget.state.formKey!.currentState!.validate()) {
            widget.bloc?.add(ProfileUpdateFormSubmit());
          }
        },
        icon: const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: Colors.white,
          size: 22,
        ),
        label: Text(
          "Guardar cambios",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
