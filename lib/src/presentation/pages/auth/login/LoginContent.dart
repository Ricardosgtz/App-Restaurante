import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';

class LoginContent extends StatefulWidget {
  final LoginBloc? bloc;
  final LoginState state;

  const LoginContent(this.bloc, this.state, {Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _emailController.clear();
    _passwordController.clear();

    // ⚡ Animación de entrada
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 45,
            right: 45,
            top: 120,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          ),
          child: Form(
            key: widget.state.formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🍊 Logo circular con animación Fade + Bounce
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      //height: 150, // 🔹 antes 200 → más compacto
                      //width: 150,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0), // 🔹 antes 18 → más pegado
                        child: ClipOval(
                          child: Image.asset(
                            'assets/img/clic.png',
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //const SizedBox(height: 0), // 🔹 Espacio mínimo entre logo y texto

                // 🧾 Título y subtítulo
                Text(
                  "Bienvenido",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                    color: primary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Inicia sesión para continuar",
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 25),

                // 📧 Campo de correo
                _textFieldEmail(),

                const SizedBox(height: 0),

                // 🔒 Campo de contraseña
                _textFieldPassword(),

                const SizedBox(height: 35),

                // 🚪 Botón de inicio de sesión
                _buttonLogin(context, primary),

                const SizedBox(height: 35),

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
                      onTap: () => Navigator.pushNamed(context, 'register'),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
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
      controller: _emailController,
      onChanged: (text) {
        widget.bloc?.add(EmailChanged(email: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El correo es requerido';
        }
        return widget.state.email.error;
      },
    );
  }

  // 🔒 Campo de contraseña
  Widget _textFieldPassword() {
    return DefaultTextField(
      label: 'Contraseña',
      icon: Icons.lock_outline,
      obscureText: true,
      controller: _passwordController,
      onChanged: (text) {
        widget.bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La contraseña es requerida';
        }
        return widget.state.password.error;
      },
    );
  }

  // 🚪 Botón de login con degradado
  Widget _buttonLogin(BuildContext context, Color primary) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (widget.state.formkey?.currentState?.validate() ?? false) {
            widget.bloc?.add(LoginSubmit());
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 8,
          shadowColor: primary.withOpacity(0.4),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((_) => null),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary,
                primary.withOpacity(0.9),
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
