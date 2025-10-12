// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
    int? id;
    int idClient;
    String alias;
    String address;
    String reference;

    Address({
        this.id,
        required this.idClient,
        required this.alias,
        required this.address,
        required this.reference,
    });

    static List<Address> fromJsonList(List<dynamic> jsonList) {
      List<Address> toList = [];
      jsonList.forEach((item) { 
        Address address = Address.fromJson(item);
        toList.add(address);
      });
      return toList;
    }

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        idClient: json["id_client"],
        alias: json["alias"],
        address: json["address"],
        reference: json["reference"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_client": idClient,
        "alias": alias,
        "address": address,
        "reference": reference,
    };
}
