import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';
import 'package:flutter_application_1/src/presentation/utils/SelectOptionlmageDialog.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Form(
        key: widget.state.formKey,
        autovalidateMode:
            _showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _headerSection(),
                  const SizedBox(height: 50),
                  _cardForm(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧑‍💼 Header con imagen de perfil y botón de cámara
  Widget _headerSection() {
    return Stack(
      children: [
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryColor, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: widget.state.image != null
                ? Image.file(widget.state.image!, fit: BoxFit.cover)
                : (widget.cliente?.image != null
                    ? Image.network(widget.cliente!.image!, fit: BoxFit.cover)
                    : Image.asset('assets/img/user_image.png', fit: BoxFit.cover)),
          ),
        ),
        Positioned(
          bottom: 15,
          right: 5,
          child: Material(
            color: AppTheme.primaryColor,
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
                padding: EdgeInsets.all(12),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 📦 Tarjeta del formulario
  Widget _cardForm(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _textFieldName(),
          _textFieldLastname(),
          _textFieldPhone(),
          const SizedBox(height: 25),
          _fabSubmit(),
        ],
      ),
    );
  }

  /// 👤 Campo Nombre
  Widget _textFieldName() {
    return DefaultTextField(
      label: 'Nombre',
      icon: CupertinoIcons.person_solid,
      color: AppTheme.primaryColor,
      initialValue: widget.cliente?.name ?? '',
      onChanged: (text) {
        widget.bloc?.add(ProfileUpdateNameChanged(name: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa el nombre' : null;
        }
        return null;
      },
    );
  }

  /// 👤 Campo Apellido
  Widget _textFieldLastname() {
    return DefaultTextField(
      label: 'Apellido',
      icon: CupertinoIcons.person,
      color: AppTheme.primaryColor,
      initialValue: widget.cliente?.lastname ?? '',
      onChanged: (text) {
        widget.bloc?.add(ProfileUpdateLastnameChanged(lastname: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa el apellido' : null;
        }
        return null;
      },
    );
  }

  /// 📞 Campo Teléfono
  Widget _textFieldPhone() {
    return DefaultTextField(
      label: 'Teléfono',
      icon: CupertinoIcons.phone_solid,
      color: AppTheme.primaryColor,
      initialValue: widget.cliente?.phone ?? '',
      onChanged: (text) {
        widget.bloc?.add(ProfileUpdatePhoneChanged(phone: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa el teléfono' : null;
        }
        return null;
      },
    );
  }

  /// 🧡 Botón Guardar
  Widget _fabSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 55,
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
        ),
        label: Text(
          "Guardar",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 4,
          shadowColor: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }
}
