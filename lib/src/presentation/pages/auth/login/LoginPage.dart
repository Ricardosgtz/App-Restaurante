import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/LoginContent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc? _bloc;

  @override
  void initState() {
    // EJECUTA UNA SOLA VEZ CUANDO CARGA LA PANTALLA
    super.initState();
    //WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //  _loginBlocCubit?.dispose();
    //});
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<LoginBloc>(context, listen: false);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            final responseState = state.response;
            if (responseState is Error) {
              Fluttertoast.showToast(
                msg: responseState.message,
                toastLength: Toast.LENGTH_LONG,
              );
            } else if (responseState is Success) {
              final authResponse = responseState.data as AuthResponse;
              //_bloc?.add(LoginFormReset());
              _bloc?.add(LoginSaveUserSession(authResponse: authResponse));
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
              });
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final responseState = state.response;
              if (responseState is Loading) {
                return Stack(
                  children: [
                    LoginContent(_bloc, state),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
              return LoginContent(_bloc, state);
            },
          ),
        ),
      ),
    );
  }
}
