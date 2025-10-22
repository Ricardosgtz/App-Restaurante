import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
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
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: state.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🍽️ Ícono circular igual al login
                Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.95),
                        primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.set_meal_rounded,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 18),

                // ✨ Título
                Text(
                  "Crea tu cuenta",
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Regístrate para comenzar a ordenar",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // 📋 Campos (más juntos)
                _buildField(
                  label: 'Nombre',
                  icon: Icons.person_rounded,
                  onChanged: (text) {
                    bloc?.add(RegisterNameChanged(name: BlocFormItem(value: text)));
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Ingresa tu nombre' : null,
                ),
                _buildField(
                  label: 'Apellido',
                  icon: Icons.person_outline_rounded,
                  onChanged: (text) {
                    bloc?.add(
                        RegisterLastnameChanged(lastname: BlocFormItem(value: text)));
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Ingresa tu apellido' : null,
                ),
                _buildField(
                  label: 'Correo electrónico',
                  icon: Icons.alternate_email_rounded,
                  onChanged: (text) {
                    bloc?.add(RegisterEmailChanged(email: BlocFormItem(value: text)));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu correo';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                        .hasMatch(value)) {
                      return 'Correo no válido';
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
                    if (value == null || value.isEmpty) return 'Ingresa tu teléfono';
                    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Teléfono no válido';
                    return null;
                  },
                ),
                _buildField(
                  label: 'Contraseña',
                  icon: Icons.lock_rounded,
                  obscureText: true,
                  onChanged: (text) {
                    bloc?.add(RegisterPasswordChanged(password: BlocFormItem(value: text)));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingresa tu contraseña';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                _buildField(
                  label: 'Confirmar contraseña',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  onChanged: (text) {
                    bloc?.add(RegisterConfirmPasswordChanged(
                        confirmPassword: BlocFormItem(value: text)));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Confirma tu contraseña';
                    if (value != state.password.value)
                      return 'Las contraseñas no coinciden';
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // 🧡 Botón Registrar
                SizedBox(
                  width: double.infinity,
                  height: 52,
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
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: primary.withOpacity(0.3),
                    ),
                    child: Text(
                      "CREAR CUENTA",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 🔁 Link a Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes una cuenta?",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Inicia sesión",
                        style: GoogleFonts.poppins(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Campo reutilizable
  Widget _buildField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0), // 🔹 menos espacio entre campos
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
