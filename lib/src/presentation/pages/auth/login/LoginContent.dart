import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginContent extends StatelessWidget {
  final LoginBloc? bloc;
  final LoginState state;

  const LoginContent(this.bloc, this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 40,
            right: 40,
            top: 90,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: state.formkey, // ✅ volvemos a incluir el formkey aquí
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🧡 Ícono principal dentro de un círculo degradado
                Container(
                  height: 120,
                  width: 120,
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
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.set_meal_rounded,
                    size: 70,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // 🧾 Título
                Text(
                  "Bienvenido",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Inicia sesión para continuar",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 30),

                // 📧 Campo de correo
                _textFieldEmail(),

                const SizedBox(height: 5),

                // 🔒 Campo de contraseña
                _textFieldPassword(),

                const SizedBox(height: 30),

                // 🚪 Botón de login
                _buttonLogin(context, primary),

                const SizedBox(height: 30),

                // 🧩 Enlace a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No tienes una cuenta?",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'register');
                      },
                      child: Text(
                        "Regístrate",
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          color: primary,
                          fontWeight: FontWeight.w600,
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

  // 📧 Campo de correo electrónico
  Widget _textFieldEmail() {
    return DefaultTextField(
      label: 'Correo electrónico',
      icon: Icons.alternate_email_outlined,
      onChanged: (text) {
        bloc?.add(EmailChanged(email: BlocFormItem(value: text)));
      },
      validator: (value) => state.email.error,
    );
  }

  // 🔒 Campo de contraseña
  Widget _textFieldPassword() {
    return DefaultTextField(
      label: 'Contraseña',
      icon: Icons.lock_outline,
      obscureText: true,
      onChanged: (text) {
        bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
      },
      validator: (value) => state.password.error,
    );
  }

  // 🚪 Botón de login con degradado
  Widget _buttonLogin(BuildContext context, Color primary) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // ✅ validamos que el formkey exista antes de usarlo
          if (state.formkey != null &&
              state.formkey!.currentState != null &&
              state.formkey!.currentState!.validate()) {
            bloc?.add(LoginSubmit());
          } else {
            Fluttertoast.showToast(
              msg: 'El formulario no es válido',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => null,
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withOpacity(0.95),
                primary.withOpacity(0.8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Iniciar Sesión",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
