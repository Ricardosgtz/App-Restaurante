import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';

class DeleteAddressFromSessionUseCase {

  AddressRepository addressRepository;

  DeleteAddressFromSessionUseCase(this.addressRepository);

  run() => addressRepository.deleteFromSession();

}