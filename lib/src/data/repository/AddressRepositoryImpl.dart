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
  Future<Resource<Address>> create(Address address) {
    return addressServices.create(address);
  }
  
  @override
  Future<Resource<List<Address>>> getUserAddress(int idUser) {
    return addressServices.getUserAddress(idUser);
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
  Future<Resource<bool>> delete(int id) {
    return addressServices.delete(id);
  }
  
  @override
  Future<void> deleteFromSession() async{
    await sharedPref.remove('address');
  }
  
}