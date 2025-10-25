import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';

class TokenHelper {
  static bool isTokenExpired(AuthResponse authResponse) {
    if (authResponse.token == null) return true;
    return JwtDecoder.isExpired(authResponse.token);
  }
}
