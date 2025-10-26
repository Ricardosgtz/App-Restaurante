import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class AddressRepository {

  Future<Resource<Address>> create(Address address, BuildContext context);
  Future<Resource<List<Address>>> getUserAddress(int idUser, BuildContext context);
  Future<void> saveAddressInSession(Address address);
  Future<Address?> getAddressSession();
  Future<Resource<bool>> delete(int id, BuildContext context);
  Future<void> deleteFromSession();

}