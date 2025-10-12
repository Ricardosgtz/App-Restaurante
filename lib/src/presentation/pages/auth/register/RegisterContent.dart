import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterContent extends StatelessWidget {
  final RegisterBloc? bloc;
  final RegisterState state;

  const RegisterContent(this.bloc, this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.poppins().fontFamily,
        );

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EE),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 28,
                right: 28,
                top: 40,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 60),
                child: IntrinsicHeight(
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.how_to_reg_rounded,
                          size: 100,
                          color: Color(0xFF8B0000),
                        ),
                        const SizedBox(height: 0),

                        Text(
                          "Crea tu cuenta",
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8B0000),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Regístrate para comenzar",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 0),

                        // Campos con íconos modernos y validator
                        _buildField(
                          label: 'Nombre',
                          icon: Icons.person_rounded,
                          onChanged: (text) {
                            bloc?.add(RegisterNameChanged(name: BlocFormItem(value: text)));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Ingresa tu nombre";
                            return null;
                          },
                        ),
                        _buildField(
                          label: 'Apellido',
                          icon: Icons.person_outline_rounded,
                          onChanged: (text) {
                            bloc?.add(RegisterLastnameChanged(lastname: BlocFormItem(value: text)));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Ingresa tu apellido";
                            return null;
                          },
                        ),
                        _buildField(
                          label: 'Correo electrónico',
                          icon: Icons.alternate_email_rounded,
                          onChanged: (text) {
                            bloc?.add(RegisterEmailChanged(email: BlocFormItem(value: text)));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Ingresa tu correo";
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                              return "Correo no válido";
                            }
                            return null;
                          },
                        ),
                        _buildField(
                          label: 'Teléfono',
                          icon: Icons.phone_android_rounded,
                          onChanged: (text) {
                            bloc?.add(RegisterPhoneChanged(phone: BlocFormItem(value: text)));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Ingresa tu teléfono";
                            if (!RegExp(r'^\d+$').hasMatch(value)) return "Teléfono no válido";
                            return null;
                          },
                        ),
                        _buildField(
                          label: 'Contraseña',
                          icon: Icons.key_rounded,
                          obscureText: true,
                          onChanged: (text) {
                            bloc?.add(RegisterPasswordChanged(password: BlocFormItem(value: text)));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Ingresa tu contraseña";
                            if (value.length < 6) return "Mínimo 6 caracteres";
                            return null;
                          },
                        ),
                        _buildField(
                          label: 'Confirmar contraseña',
                          icon: Icons.lock_outline_rounded,
                          obscureText: true,
                          onChanged: (text) {
                            bloc?.add(RegisterConfirmPasswordChanged(confirmPassword: BlocFormItem(value: text)));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Confirma tu contraseña";
                            if (value != state.password.value) return "Las contraseñas no coinciden";
                            return null;
                          },
                        ),

                        const SizedBox(height: 25),

                        // Botón registrar
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (state.formKey!.currentState!.validate()) {
                                bloc?.add(RegisterFormSubmit());
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'El formulario no es válido',
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B0000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "REGISTRARME",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Link a login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Ya tienes una cuenta?",
                              style: GoogleFonts.poppins(
                                color: Colors.brown[700],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Inicia sesión",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF8B0000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: DefaultTextField(
        label: label,
        icon: icon,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
