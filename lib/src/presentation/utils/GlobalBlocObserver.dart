import 'package:flutter_application_1/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/domain/utils/AuthExpiredHandler.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
 // Para acceder a navigatorKey

class GlobalBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    
    // 🔍 Detectar si algún estado tiene error de TOKEN_EXPIRED
    final nextState = change.nextState;
    
    // Intenta extraer el response del estado
    dynamic response;
    
    try {
      // Si el estado tiene un método o propiedad 'response'
      if (nextState is Map && nextState.containsKey('response')) {
        response = nextState['response'];
      } else {
        // Intenta con reflection básica (funciona con copyWith)
        final stateMap = _stateToMap(nextState);
        response = stateMap['response'];
      }
      
      // Si es un error de TOKEN_EXPIRED, manejar globalmente
      if (response is Error && response.message == 'TOKEN_EXPIRED') {
        print('🚨 Token expirado detectado globalmente en ${bloc.runtimeType}');
        _handleGlobalTokenExpired();
      }
    } catch (e) {
      // Ignorar errores de conversión
    }
  }

  Map<String, dynamic> _stateToMap(dynamic state) {
    try {
      // Intenta convertir el estado a Map usando toString y parsing
      final str = state.toString();
      // Esto es un hack simple, ajusta según tu implementación de estados
      return {'response': null};
    } catch (e) {
      return {};
    }
  }

  void _handleGlobalTokenExpired() {
    // ✅ Obtener el contexto global de la navegación
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      AuthExpiredHandler.handleUnauthorized(context);
    }
  }
}