
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';

class CreateAddressUseCase {

  AddressRepository addressRepository;

  CreateAddressUseCase(this.addressRepository);

  run(Address address) => addressRepository.create(address);

}