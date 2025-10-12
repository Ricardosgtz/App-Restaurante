import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';

class GetAddressSessionUseCase {
  AddressRepository addressRepository;

  GetAddressSessionUseCase(this.addressRepository);

  run() => addressRepository.getAddressSession();
}