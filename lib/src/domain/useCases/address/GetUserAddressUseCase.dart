import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';

class GetUserAddressUseCase {

  AddressRepository addressRepository;

  GetUserAddressUseCase(this.addressRepository);

  run(int idUser, BuildContext context) => addressRepository.getUserAddress(idUser, context);

}