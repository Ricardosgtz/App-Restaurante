import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    key: state.formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ícono moderno de restaurante
                        const Icon(
                          Icons.set_meal,
                          size: 110,
                          color: Color(0xFF8B0000),
                        ),
                        const SizedBox(height: 20),

                        // Título
                        Text(
                          "Bienvenido",
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: const Color(0xFF8B0000),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Inicia sesión para continuar o registrate",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email
                        _textFieldEmail(),

                        const SizedBox(height: 0),

                        // Password
                        _textFildPassword(),

                        const SizedBox(height: 30),

                        // Botón login
                        _buttonLogin(context),

                        const SizedBox(height: 25),

                        // Link a registro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿No tienes una cuenta?",
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.brown[700],
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'register');
                              },
                              child: Text(
                                "Regístrate",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF8B0000),
                                  fontWeight: FontWeight.bold,
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
          },
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return DefaultTextField(
      label: 'Correo electrónico',
      icon: Icons.alternate_email_outlined,
      onChanged: (text) {
        bloc?.add(EmailChanged(email: BlocFormItem(value: text)));
      },
      validator: (value) {
        return state.email.error;
      },
    );
  }

  Widget _textFildPassword() {
    return DefaultTextField(
      label: 'Contraseña',
      icon: Icons.key,
      obscureText: true,
      onChanged: (text) {
        bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
      },
      validator: (value) {
        return state.password.error;
      },
    );
  }

  Widget _buttonLogin(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (state.formkey!.currentState!.validate()) {
            bloc?.add(LoginSubmit());
          } else {
            Fluttertoast.showToast(
              msg: 'El formulario no es válido',
              toastLength: Toast.LENGTH_LONG,
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
          "Iniciar Sesión",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
