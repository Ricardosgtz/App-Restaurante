import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharedPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/AddressServices.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/repository/AddressRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class AddressRepositoryImpl implements AddressRepository {

  AddressServices addressServices;
  SharedPref sharedPref;

  AddressRepositoryImpl(this.addressServices, this.sharedPref);

  @override
  Future<Resource<Address>> create(Address address, BuildContext context) {
    return addressServices.create(address, context);
  }
  
  @override
  Future<Resource<List<Address>>> getUserAddress(int idUser, BuildContext context) {
    return addressServices.getUserAddress(idUser, context);
  }
  
  @override
  Future<void> saveAddressInSession(Address address) async{
    await sharedPref.save('address', address.toJson());
  }
  
  @override
  Future<Address?> getAddressSession() async{
    final data = await sharedPref. read('address');
    if(data != null) {
      Address address = Address.fromJson(data);
      return address;
    }
    return null;
  }
  
  @override
  Future<Resource<bool>> delete(int id, BuildContext context) {
    return addressServices.delete(id, context);
  }
  
  @override
  Future<void> deleteFromSession() async{
    await sharedPref.remove('address');
  }
  
}