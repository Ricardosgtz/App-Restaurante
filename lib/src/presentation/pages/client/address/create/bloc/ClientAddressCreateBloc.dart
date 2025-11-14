import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/address/AddressUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateState.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientAddressCreateBloc
    extends Bloc<ClientAddressCreateEvent, ClientAddressCreateState> {
  AddressUseCases addressUseCases;
  AuthUseCases authUseCases;

  ClientAddressCreateBloc(this.addressUseCases, this.authUseCases)
    : super(ClientAddressCreateState()) {
    on<ClientAddressCreateInitEvent>(_onClientAddressCreateInitEvent);
    on<AliasChanged>(_onAliasChanged);
    on<AddressChanged>(_onAddressChanged);
    on<ReferenceChanged>(_onReferenceChanged);
    on<FormSubmit>(_onFormSubmit);
  }

  final formKey = GlobalKey<FormState>();

  Future<void> _onClientAddressCreateInitEvent(
    ClientAddressCreateInitEvent event,
    Emitter<ClientAddressCreateState> emit,
  ) async {
    AuthResponse? authResponse = await authUseCases.getUserSession.run();
    emit(state.copyWith(formKey: formKey));
    if (authResponse != null) {
      emit(state.copyWith(formKey: formKey, idClient: authResponse.cliente.id));
    }
  }

  Future<void> _onAliasChanged(
    AliasChanged event,
    Emitter<ClientAddressCreateState> emit,
  ) async {
    emit(
      state.copyWith(
        alias: BlocFormItem(
          value: event.alias.value,
          error: event.alias.value.isNotEmpty ? null : 'Ingresa el alias',
        ),
        formKey: formKey,
      ),
    );
  }

  Future<void> _onAddressChanged(
    AddressChanged event,
    Emitter<ClientAddressCreateState> emit,
  ) async {
    emit(
      state.copyWith(
        address: BlocFormItem(
          value: event.address.value,
          error: event.address.value.isNotEmpty ? null : 'Ingresa la direccion',
        ),
        formKey: formKey,
      ),
    );
  }

  Future<void> _onReferenceChanged(
    ReferenceChanged event,
    Emitter<ClientAddressCreateState> emit,
  ) async {
    emit(
      state.copyWith(
        reference: BlocFormItem(
          value: event.reference.value,
          error: event.reference.value.isNotEmpty ? null : 'Ingresa el barrio',
        ),
        formKey: formKey,
      ),
    );
  }

  Future<void> _onFormSubmit(
    FormSubmit event,
    Emitter<ClientAddressCreateState> emit,
  ) async {
    emit(state.copyWith(response: Loading(), formKey: formKey));
    AuthResponse? authResponse = await authUseCases.getUserSession.run();
    if (authResponse == null) {
      emit(
        state.copyWith(
          response: Error(
            'No hay sesión activa. Por favor inicia sesión nuevamente.',
          ),
          formKey: formKey,
        ),
      );
      return;
    }
    final updatedState = state.copyWith(
      idClient: authResponse.cliente.id,
      formKey: formKey,
    );
    Resource response = await addressUseCases.create.run(
      updatedState.toAddress(),
      event.context,
    );

    emit(
      state.copyWith(
        response: response,
        idClient: authResponse.cliente.id,
        formKey: formKey,
      ),
    );
  }
}
