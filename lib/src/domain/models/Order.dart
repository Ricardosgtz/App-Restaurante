import 'dart:convert';
import 'package:flutter_application_1/src/domain/models/Product.dart';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int id;
  Client client;
  Restaurant restaurant;
  OrderInfo order;
  Address? address;
  Status status;
  List<OrderDetail> orderdetails;
  double total;
  DateTime createdAt;
  String? arrivalTime;

  Order({
    required this.id,
    required this.client,
    required this.restaurant,
    required this.order,
    this.address,
    required this.status,
    required this.orderdetails,
    required this.total,
    required this.createdAt,
    this.arrivalTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    client: Client.fromJson(json["client"]),
    restaurant: Restaurant.fromJson(json["restaurant"]),
    order: OrderInfo.fromJson(json["order"]),
    address: json["address"] != null ? Address.fromJson(json["address"]) : null,
    status: Status.fromJson(json["status"]),
    // ✅ Manejo seguro de null
    orderdetails:
        json["orderdetails"] != null
            ? List<OrderDetail>.from(
              json["orderdetails"].map((x) => OrderDetail.fromJson(x)),
            )
            : [],
    total: double.tryParse(json["total"].toString()) ?? 0.0,
    createdAt: DateTime.parse(json["created_at"]),
    arrivalTime: json["arrival_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client": client.toJson(),
    "restaurant": restaurant.toJson(),
    "order": order.toJson(),
    "address": address?.toJson(),
    "status": status.toJson(),
    "orderdetails": List<dynamic>.from(orderdetails.map((x) => x.toJson())),
    "total": total,
    "created_at": createdAt.toIso8601String(),
    "arrival_time": arrivalTime,
  };
}

class Client {
  int id;
  String name;
  String? lastname;
  String? email;
  String? phone;

  Client({
    required this.id,
    required this.name,
    this.lastname,
    this.email,
    this.phone,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    name: json["name"],
    lastname: json["lastname"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lasname": lastname,
    "email": email,
    "phone": phone,
  };
}

class Restaurant {
  int id;
  String name;
  String? accountNumber; // 🆕 número de cuenta
  String? clabe; // 🆕 clave interbancaria

  Restaurant({
    required this.id,
    required this.name,
    this.accountNumber,
    this.clabe,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    accountNumber: json["account_number"],
    clabe: json["clabe"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "account_number": accountNumber,
    "clabe": clabe,
  };
}

class OrderInfo {
  String type;
  String? note;

  OrderInfo({required this.type, this.note});

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      OrderInfo(type: json["type"], note: json["note"]);

  Map<String, dynamic> toJson() => {"type": type, "note": note};
}

class Address {
  int? id;
  String? alias;
  String address;
  String? reference;

  Address({this.id, this.alias, required this.address, this.reference});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    alias: json["alias"],
    address: json["address"],
    reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "alias": alias,
    "address": address,
    "reference": reference,
  };
}

class Status {
  int id;
  String name;
  String description;

  Status({required this.id, required this.name, required this.description});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}

class OrderDetail {
  int productId;
  Product product;
  int quantity;
  String unitPrice;
  double subtotal;

  OrderDetail({
    required this.productId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    productId: json["product_id"],
    product: Product.fromJson(json["product"]),
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    subtotal: double.parse(json["subtotal"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product": product.toJson(),
    "quantity": quantity,
    "unit_price": unitPrice,
    "subtotal": subtotal,
  };
}
