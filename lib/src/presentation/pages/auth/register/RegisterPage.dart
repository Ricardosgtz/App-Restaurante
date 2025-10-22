import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/RegisterContent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/register/bloc/RegisterState.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<RegisterBloc>(context);

    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          final responseState = state.response;

          if (responseState is Error) {
            await AlertHelper.showAlertDialog(
              context: context,
              title: "Error",
              message: responseState.message,
              isSuccess: false,
            );
          } else if (responseState is Success) {
            _bloc?.add(RegisterFormReset());

            await AlertHelper.showAlertDialog(
              context: context,
              title: "¡Registro exitoso!",
              message: "Tu cuenta ha sido creada correctamente.",
              isSuccess: true,
              onClose: () {
                Navigator.pop(context); // ✅ Regresa a la pantalla de login
              },
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            final responseState = state.response;

            if (responseState is Loading) {
              return Stack(
                children: [
                  RegisterContent(_bloc, state),
                  Container(
                    color: Colors.black.withOpacity(0.50),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SpinKitThreeBounce(
                            color: Colors.white,
                            size: 32,
                            duration: Duration(milliseconds: 900),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            "Creando tu cuenta...",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return RegisterContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
