import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/AuthService.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final SharedPref sharedPref;

  AuthRepositoryImpl(this.authService, this.sharedPref);

  @override
  Future<Resource<AuthResponse>> login(String email, String password) {
    return authService.login(email, password);
  }

  @override
  Future<Resource<AuthResponse>> register(Cliente cliente) {
    return authService.register(cliente);
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await sharedPref.read('cliente');
    if (data != null) {
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return authResponse;
    }
    return null;
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    await sharedPref.save('cliente', authResponse.toJson());
  }

  @override
  Future<bool> logout() async {
    try {
      // 🔥 Lista de todas las claves a eliminar
      final keysToRemove = [
        'cliente',       // Usuario principal
        'address',       // Dirección activa
        'shopping_bag',  // Bolsa de compras
        'token',         // Token JWT (si existe)
      ];

      // Eliminar todas las claves
      bool allSuccess = true;
      for (String key in keysToRemove) {
        final result = await sharedPref.remove(key);
        if (!result) {
          print('⚠️ WARNING - No se pudo eliminar la clave: $key');
          allSuccess = false;
        } else {
          print('✅ Clave eliminada: $key');
        }
      }

      // Debug: Verificar que todo se eliminó
      print('🔍 LOGOUT - Limpieza completa: $allSuccess');
      
      // Verificación adicional: intentar leer 'cliente'
      final clienteData = await sharedPref.read('cliente');
      if (clienteData != null) {
        print('❌ ERROR - La clave "cliente" aún existe después del logout');
        return false;
      }
      
      print('✅ LOGOUT - Sesión eliminada correctamente');
      return allSuccess;
      
    } catch (e) {
      print('❌ ERROR en logout: $e');
      return false;
    }
  }
}