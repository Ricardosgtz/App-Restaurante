import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';

class AuthExpiredHandler {
  static bool _isHandling = false;

  static Future<void> handleUnauthorized(BuildContext context) async {
    if (_isHandling) return;
    _isHandling = true;

    try {
      final SharedPref sharedPref = SharedPref();
      await _clearAllSessionData(sharedPref);
      ResponseCache().clear();
      await Future.delayed(const Duration(milliseconds: 200));

      if (context.mounted) {
        MyApp.restartApp(context);
        await Future.delayed(const Duration(milliseconds: 500));

        if (navigatorKey.currentContext != null) {
          Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );

          Future.delayed(const Duration(milliseconds: 300), () {
            if (navigatorKey.currentContext != null) {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                const SnackBar(
                  content: Text('Tu sesión ha expirado. Por favor, inicia sesión nuevamente.'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          });
        }
      }
    } catch (_) {} finally {
      Future.delayed(const Duration(seconds: 2), () {
        _isHandling = false;
      });
    }
  }

  static Future<void> _clearAllSessionData(SharedPref sharedPref) async {
    try {
      final keysToRemove = [
        'cliente',
        'user',
        'cart',
        'shopping_bag',
        'favorites',
        'last_address',
        'selected_category',
        'orders_cache',
        'products_cache',
      ];

      for (final key in keysToRemove) {
        await sharedPref.remove(key);
      }
    } catch (_) {
      await sharedPref.remove('cliente');
      await sharedPref.remove('user');
    }
  }

  static Future<bool> hasActiveSession() async {
    try {
      final SharedPref sharedPref = SharedPref();
      final data = await sharedPref.read('cliente');
      return data != null;
    } catch (_) {
      return false;
    }
  }
}
