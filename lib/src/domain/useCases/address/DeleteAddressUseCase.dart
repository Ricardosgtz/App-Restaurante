import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';

class DeleteAddressUseCase {

  AddressRepository addressRepository;

  DeleteAddressUseCase(this.addressRepository);

  run(int id, BuildContext context) => addressRepository.delete(id, context);

}