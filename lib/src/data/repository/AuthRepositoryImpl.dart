import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/AuthService.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRepositoryImpl implements AuthRepository {
  AuthService authService;
  SharedPref sharedPref;
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
    sharedPref.save('cliente', authResponse.toJson());
  }

  @override
  Future<bool> logout() async {
    return await sharedPref.remove('cliente');
  }

}
