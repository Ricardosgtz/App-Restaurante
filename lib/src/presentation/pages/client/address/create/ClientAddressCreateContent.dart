import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultIconBack.dart';
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
                  const SizedBox(height: 30),
                  _cardAddressForm(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧭 Encabezado superior con icono e instrucciones
  Widget _headerSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(18),
          child: Icon(
            CupertinoIcons.location_solid,
            color: AppTheme.primaryColor,
            size: 160,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nueva dirección',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Agrega un alias y los detalles de tu ubicación para poder identificarla fácilmente.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /// 📦 Tarjeta con los campos del formulario
  Widget _cardAddressForm(BuildContext context) {
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
          _textFieldAlias(),
          _textFieldAddress(),
          _textFieldReference(),
          const SizedBox(height: 25),
          _fabSubmit(),
        ],
      ),
    );
  }

  /// 🏠 Campo Alias
  Widget _textFieldAlias() {
    return DefaultTextField(
      label: 'Alias (ej. Casa, Oficina)',
      icon: CupertinoIcons.home,
      color: AppTheme.primaryColor,
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
    return DefaultTextField(
      label: 'Dirección completa',
      icon: CupertinoIcons.map_pin_ellipse,
      color: AppTheme.primaryColor,
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
    return DefaultTextField(
      label: 'Referencia o punto cercano',
      icon: CupertinoIcons.location,
      color: AppTheme.primaryColor,
      onChanged: (text) {
        widget.bloc?.add(ReferenceChanged(reference: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _showErrors ? 'Ingresa la referencia' : null;
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
            _showErrors = true; // 👈 activa los mensajes
          });

          if (widget.state.formKey!.currentState!.validate()) {
            widget.bloc?.add(FormSubmit());
          }
        },
        icon: const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: Colors.white,
        ),
        label: Text(
          "Guardar dirección",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 4,
          shadowColor: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }
}
