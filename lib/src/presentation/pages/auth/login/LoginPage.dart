import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/LoginContent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc? _bloc;

  // ✅ Bandera para controlar cuando está navegando
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<LoginBloc>(context, listen: false);
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final responseState = state.response;

          if (responseState is Error) {
            // ✅ Resetear la bandera si hay error
            setState(() {
              _isNavigating = false;
            });

            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
            );
          } else if (responseState is Success && !_isNavigating) {
            // ✅ Activar bandera para mantener el loading visible
            setState(() {
              _isNavigating = true;
            });

            final authResponse = responseState.data as AuthResponse;
            _bloc?.add(LoginSaveUserSession(authResponse: authResponse));

            // ✅ Delay de 2.5 segundos antes de navegar
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'client/home',
                  (route) => false,
                );
              }
            });
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final responseState = state.response;

            // 🌀 Pantalla de carga si está cargando o navegando
            if (responseState is Loading || _isNavigating) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Color(0xFFFFF3E0),
                      Color(0xFFFFE0B2),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🟠 Logo circular con animación
                      AnimatedScale(
                        scale: _isNavigating ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          height: 200,
                          width: 200,
                          // 🖼️ Imagen original del logo (sin color blanco)
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.asset(
                              'assets/img/clic.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 0),

                      // ✨ Texto con animación Fade + Slide
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _isNavigating
                              ? "¡Bienvenido!"
                              : "Conectando con tu cuenta...",
                          key: ValueKey(_isNavigating),
                          style: GoogleFonts.poppins(
                            color: Colors.orange.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔄 Loader animado
                      const SpinKitThreeBounce(
                        color: Colors.orange,
                        size: 30,
                        duration: Duration(milliseconds: 1000),
                      ),

                      const SizedBox(height: 25),

                      // 💬 Mensaje secundario animado
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _isNavigating
                              ? "Preparando tu experiencia..."
                              : "Por favor espera un momento...",
                          key: ValueKey(_isNavigating ? 'welcome' : 'waiting'),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[700],
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 🟢 Estado normal
            return LoginContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
