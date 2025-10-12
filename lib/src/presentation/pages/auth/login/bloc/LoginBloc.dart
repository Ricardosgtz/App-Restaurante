import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthUseCases authUseCases;

  LoginBloc(this.authUseCases) : super(LoginState()) {
    on<InitEvent>(_onInitEvent);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmit>(_onLoginSubmit);
    on<LoginFormReset>(_onLoginFormReset);
    on<LoginSaveUserSession>(_onLoginSaveUserSession);
  }

  final formkey = GlobalKey<FormState>();

  Future<void> _onInitEvent(InitEvent event, Emitter<LoginState> emit) async {
    AuthResponse? authResponse = await authUseCases.getUserSession.run();
    print('USUARIO DE SESSION: ${authResponse?.toJson()}');
    emit(state.copywith(formkey: formkey));

    if(authResponse != null) {
      emit(state.copywith(response: Success(authResponse), formkey: formkey));
    }
  }

  Future<void> _onLoginSaveUserSession(
    LoginSaveUserSession event,
    Emitter<LoginState> emit,
  ) async {
    await authUseCases.saveUserSession.run(event.authResponse);
  }

  Future<void> _onLoginFormReset(
    LoginFormReset event,
    Emitter<LoginState> emit,
  ) async {
    state.formkey?.currentState?.reset();
  }

  Future<void> _onEmailChanged(
    EmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copywith(
        email: BlocFormItem(
          value: event.email.value,
          error: event.email.value.isNotEmpty ? null : 'Ingresa el email',
        ),
        formkey: formkey,
      ),
    );
  }

  Future<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copywith(
        password: BlocFormItem(
          value: event.password.value,
          error:
              event.password.value.isNotEmpty &&
                      event.password.value.length >= 6
                  ? null
                  : 'Ingresa el password',
        ),
        formkey: formkey,
      ),
    );
  }

  Future<void> _onLoginSubmit(
    LoginSubmit event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copywith(response: Loading(), formkey: formkey));
    await Future.delayed(Duration(seconds: 4));
    Resource response = await authUseCases.login.run(
      state.email.value,
      state.password.value,
    );
    emit(state.copywith(response: response, formkey: formkey));
  }
}