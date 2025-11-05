import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/ResponseCache.dart';

class AuthExpiredHandler {
  static bool _isHandling = false;

  static Future<void> handleUnauthorized(BuildContext context) async {
    // ✅ Evitar ejecuciones simultáneas
    if (_isHandling) {
      print('⚠️ Ya se está manejando el cierre de sesión');
      return;
    }

    _isHandling = true;

    try {
      final SharedPref sharedPref = SharedPref();
      
      print('🔄 Iniciando cierre de sesión...');
      
      // 🧹 1. Limpiar SharedPrefs completo
      await _clearAllSessionData(sharedPref);
      
      // 🧹 2. Limpiar caché de servicios
      ResponseCache().clear();
      print('💾 Caché limpiada');
      
      // ⏳ Pausa breve para asegurar limpieza
      await Future.delayed(const Duration(milliseconds: 200));

      // 🔄 3. REINICIAR APP COMPLETA
      if (context.mounted) {
        print('🔄 Reiniciando app...');
        MyApp.restartApp(context);
        
        // 4. Esperar a que se reinicie
        await Future.delayed(const Duration(milliseconds: 500));
        
        // 5. Navegar al login usando navigatorKey
        if (navigatorKey.currentContext != null) {
          Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => LoginPage(),
            ),
            (route) => false, // Elimina todo el stack
          );
          
          // 6. Mostrar mensaje después de navegar
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
      
      print('✅ Sesión cerrada y app reiniciada correctamente');
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
    } finally {
      // 🔓 Liberar el flag después de 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        _isHandling = false;
      });
    }
  }

  /// 🧹 Limpia TODOS los datos de sesión
  static Future<void> _clearAllSessionData(SharedPref sharedPref) async {
    try {
      // Lista de todas las claves que podrías tener guardadas
      final keysToRemove = [
        'cliente',           // Usuario autenticado
        'user',              // Por si usas otra clave
        'cart',              // Carrito de compras
        'shopping_bag',      // Bolsa de compras
        'favorites',         // Favoritos
        'last_address',      // Última dirección usada
        'selected_category', // Categoría seleccionada
        'orders_cache',      // Caché de órdenes
        'products_cache',    // Caché de productos
        // Agrega aquí cualquier otra clave que uses
      ];

      for (final key in keysToRemove) {
        await sharedPref.remove(key);
      }

      print('✅ SharedPrefs limpiado completamente');
    } catch (e) {
      print('❌ Error limpiando datos: $e');
      // Fallback: intentar borrar al menos el cliente
      await sharedPref.remove('cliente');
      await sharedPref.remove('user');
    }
  }

  /// 🔍 Método auxiliar para verificar si hay una sesión activa
  static Future<bool> hasActiveSession() async {
    try {
      final SharedPref sharedPref = SharedPref();
      final data = await sharedPref.read('cliente');
      return data != null;
    } catch (e) {
      return false;
    }
  }
}