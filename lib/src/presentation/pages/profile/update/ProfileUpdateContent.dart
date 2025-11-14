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
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart'; // ✅ Importamos tu widget
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
              _formCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 👤 Encabezado con imagen
  Widget _headerSection(Color primary) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 180,
              height: 180,
              child: ClipOval(
                child:
                    widget.state.image != null
                        ? Image.file(widget.state.image!, fit: BoxFit.cover)
                        : (widget.cliente?.image != null
                            ? Image.network(
                              widget.cliente!.image!,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              'assets/img/no-perfil.jpg',
                              fit: BoxFit.cover,
                            )),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  SelectOpcionImageDialog(
                    context,
                    () => widget.bloc?.add(ProfileUpdatePickImage()),
                    () => widget.bloc?.add(ProfileUpdateTakePhoto()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.camera_fill,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Editar perfil',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Actualiza tu información personal',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  /// 📋 Formulario con campos DefaultTextField
  Widget _formCard(BuildContext context) {
    final bloc = widget.bloc;
    final cliente = widget.cliente;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        //border: Border.all(color: Colors.grey.withOpacity(0.15)),
        //boxShadow: [
        //  BoxShadow(
        //    color: Colors.black.withOpacity(0.08),
        //    blurRadius: 12,
        //    offset: const Offset(0, 4),
        //  ),
        //],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextField(
            label: 'Nombre',
            icon: Icons.person_rounded,
            initialValue: cliente?.name ?? '',
            onChanged:
                (text) => bloc?.add(
                  ProfileUpdateNameChanged(name: BlocFormItem(value: text)),
                ),
            validator:
                (value) =>
                    (value == null || value.isEmpty) && _showErrors
                        ? 'Ingresa el nombre'
                        : null,
          ),
          DefaultTextField(
            label: 'Apellido',
            icon: Icons.person_outline_rounded,
            initialValue: cliente?.lastname ?? '',
            onChanged:
                (text) => bloc?.add(
                  ProfileUpdateLastnameChanged(
                    lastname: BlocFormItem(value: text),
                  ),
                ),
            validator:
                (value) =>
                    (value == null || value.isEmpty) && _showErrors
                        ? 'Ingresa el apellido'
                        : null,
          ),
          DefaultTextField(
            label: 'Teléfono',
            icon: Icons.phone_android_rounded,
            initialValue: cliente?.phone ?? '',
            textInputType: TextInputType.phone,
            onChanged:
                (text) => bloc?.add(
                  ProfileUpdatePhoneChanged(phone: BlocFormItem(value: text)),
                ),
            validator:
                (value) =>
                    (value == null || value.isEmpty) && _showErrors
                        ? 'Ingresa el teléfono'
                        : null,
          ),
          const SizedBox(height: 30),
          _saveButton(),
        ],
      ),
    );
  }

  /// 💾 Botón guardar
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
            widget.bloc?.add(ProfileUpdateFormSubmit(context));
          }
        },
        icon: const Icon(
          CupertinoIcons.checkmark_circle,
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
