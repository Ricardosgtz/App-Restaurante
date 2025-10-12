import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';

class SaveAddressInSessionUseCase {

  AddressRepository addressRepository;

  SaveAddressInSessionUseCase(this.addressRepository);

  run(Address address) => addressRepository.saveAddressInSession(address);

}