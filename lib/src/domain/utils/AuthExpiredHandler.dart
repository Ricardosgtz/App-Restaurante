import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/blocProviders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';

class AuthExpiredHandler {
  static Future<void> handleUnauthorized(BuildContext context) async {
    final SharedPref sharedPref = SharedPref();
    await sharedPref.remove('cliente');

    // 🔁 Reinicia toda la app con nuevos blocs
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: blocProviders,
          child: const LoginPage(),
        ),
      ),
      (route) => false,
    );
  }
}
