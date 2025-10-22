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
            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
            );
          } else if (responseState is Success) {
            final authResponse = responseState.data as AuthResponse;
            _bloc?.add(LoginSaveUserSession(authResponse: authResponse));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'client/home',
                (route) => false,
              );
            });
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final responseState = state.response;

            // 🌀 Mostrar pantalla de carga con tu icono y degradado
            if (responseState is Loading) {
              return Stack(
                children: [
                  LoginContent(_bloc, state),
                  Container(
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
                          // 🍽️ Ícono circular igual al del login
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
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.set_meal_rounded,
                              color: Colors.white,
                              size: 70,
                            ),
                          ),

                          const SizedBox(height: 35),

                          // ✨ Texto principal estilo WhatsApp
                          Text(
                            "Conectando con tu cuenta...",
                            style: GoogleFonts.poppins(
                              color: Colors.orange.shade700,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 25),

                          // 🟠 Loader animado elegante
                          const SpinKitThreeBounce(
                            color: Colors.orange,
                            size: 30,
                            duration: Duration(milliseconds: 1000),
                          ),

                          const SizedBox(height: 25),

                          // 💬 Mensaje secundario más pequeño
                          Text(
                            "Por favor espera un momento...",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // 🟢 Estado normal (sin loading)
            return LoginContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
