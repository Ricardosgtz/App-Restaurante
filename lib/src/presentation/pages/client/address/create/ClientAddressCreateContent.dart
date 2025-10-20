import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientAddressCreateContent extends StatefulWidget {
  final ClientAddressCreateBloc? bloc;
  final ClientAddressCreateState state;

  const ClientAddressCreateContent(this.bloc, this.state, {super.key});

  @override
  State<ClientAddressCreateContent> createState() =>
      _ClientAddressCreateContentState();
}

class _ClientAddressCreateContentState
    extends State<ClientAddressCreateContent> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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

  /// 🧭 Encabezado elegante
  Widget _headerSection(Color primary) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(20),
          child: Icon(
            CupertinoIcons.location_solid,
            color: primary,
            size: 95,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Agregar dirección',
          style: GoogleFonts.poppins(
            color: primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Completa los datos para guardar tu nueva ubicación.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /// 🧊 Tarjeta del formulario (estilo glass moderno)
  Widget _glassCardForm(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
              _textFieldAlias(),
              const SizedBox(height: 18),
              _textFieldAddress(),
              const SizedBox(height: 18),
              _textFieldReference(),
              const SizedBox(height: 30),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏠 Campo Alias
  Widget _textFieldAlias() {
    return _buildInputContainer(
      icon: CupertinoIcons.house_fill,
      label: 'Alias (ej. Casa, Oficina)',
      onChanged: (text) {
        widget.bloc?.add(AliasChanged(alias: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa el alias' : null;
        }
        return null;
      },
    );
  }

  /// 📍 Campo Dirección
  Widget _textFieldAddress() {
    return _buildInputContainer(
      icon: CupertinoIcons.map_pin_ellipse,
      label: 'Dirección completa',
      onChanged: (text) {
        widget.bloc?.add(AddressChanged(address: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa la dirección' : null;
        }
        return null;
      },
    );
  }

  /// 🗺️ Campo Referencia
  Widget _textFieldReference() {
    return _buildInputContainer(
      icon: CupertinoIcons.location_solid,
      label: 'Referencia o punto cercano',
      onChanged: (text) {
        widget.bloc
            ?.add(ReferenceChanged(reference: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa la referencia' : null;
        }
        return null;
      },
    );
  }

  /// 🔤 Contenedor de campo personalizado
  Widget _buildInputContainer({
    required IconData icon,
    required String label,
    required Function(String) onChanged,
    required String? Function(String?) validator,
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

  /// 🧡 Botón Guardar dirección tipo píldora
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
            widget.bloc?.add(FormSubmit());
          }
        },
        icon: const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: Colors.white,
          size: 22,
        ),
        label: Text(
          "Guardar dirección",
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
