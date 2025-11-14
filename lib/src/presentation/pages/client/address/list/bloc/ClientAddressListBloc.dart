import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/address/AddressUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListState.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ClientAddressListBloc
    extends Bloc<ClientAddressListEvent, ClientAddressListState> {
  AddressUseCases addressUseCases;
  AuthUseCases authUseCases;

  ClientAddressListBloc(this.addressUseCases, this.authUseCases)
    : super(ClientAddressListState()) {
    on<GetUserAddress>(_onGetUserAddress);
    on<ChangeRadioValue>(_onChangeRadioValue);
    on<SetAddressSession>(_onSetAddressSession);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onGetUserAddress(
    GetUserAddress event,
    Emitter<ClientAddressListState> emit,
  ) async {
    AuthResponse? authResponse = await authUseCases.getUserSession.run();
    if (authResponse != null) {
      emit(state.copyWith(response: Loading()));
      Resource response = await addressUseCases.getUserAddress.run(
        authResponse.cliente.id!,
        event.context,
      );
      emit(state.copyWith(response: response));
    }
  }

  Future<void> _onChangeRadioValue(
    ChangeRadioValue event,
    Emitter<ClientAddressListState> emit,
  ) async {
    emit(
      state.copyWith(
        radioValue: event.radioValue,
        addressSelected: event.address,
      ),
    );

    await addressUseCases.saveAddressInSession.run(event.address);
  }

  Future<void> _onSetAddressSession(
    SetAddressSession event,
    Emitter<ClientAddressListState> emit,
  ) async {
    Address? addressSession = await addressUseCases.getAddressSession.run();
    if (addressSession != null) {
      int index = event.addressList.indexWhere(
        (address) => address.id == addressSession.id,
      );
      if (index != -1) {
        emit(state.copyWith(radioValue: index));
      }
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<ClientAddressListState> emit,
  ) async {
    emit(state.copyWith(response: Loading()));
    Resource response = await addressUseCases.delete.run(
      event.id,
      event.context,
    );
    emit(state.copyWith(response: response));
    Address? addressSession = await addressUseCases.getAddressSession.run();
    if (addressSession != null) {
      if (addressSession.id == event.id) {
        await addressUseCases.deleteFromSession.run();
        emit(state.copyWith(radioValue: null));
      }
    }
  }
}
