// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    int id;
    Client client;
    Address address;
    Status status;
    String orderType;
    String note;
    DateTime createdAt;
    List<Detail> details;

    Order({
        required this.id,
        required this.client,
        required this.address,
        required this.status,
        required this.orderType,
        required this.note,
        required this.createdAt,
        required this.details,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        client: Client.fromJson(json["client"]),
        address: Address.fromJson(json["address"]),
        status: Status.fromJson(json["status"]),
        orderType: json["order_type"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client": client.toJson(),
        "address": address.toJson(),
        "status": status.toJson(),
        "order_type": orderType,
        "note": note,
        "created_at": createdAt.toIso8601String(),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Address {
    int id;
    int idClient;
    String alias;
    String address;
    String reference;
    DateTime createdAt;
    DateTime updatedAt;

    Address({
        required this.id,
        required this.idClient,
        required this.alias,
        required this.address,
        required this.reference,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        idClient: json["id_client"],
        alias: json["alias"],
        address: json["address"],
        reference: json["reference"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_client": idClient,
        "alias": alias,
        "address": address,
        "reference": reference,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Client {
    int id;
    String name;
    String lastname;
    String email;
    String phone;
    String image;

    Client({
        required this.id,
        required this.name,
        required this.lastname,
        required this.email,
        required this.phone,
        required this.image,
    });

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "image": image,
    };
}

class Detail {
    Product product;
    int quantity;
    String unitPrice;
    int lineTotal;
    DateTime createdAt;
    DateTime updatedAt;

    Detail({
        required this.product,
        required this.quantity,
        required this.unitPrice,
        required this.lineTotal,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
        unitPrice: json["unit_price"],
        lineTotal: json["line_total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
        "unit_price": unitPrice,
        "line_total": lineTotal,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Product {
    int id;
    int idCategory;
    String name;
    String description;
    String price;
    String image1;
    String image2;
    DateTime createdAt;
    DateTime updatedAt;
    bool available;

    Product({
        required this.id,
        required this.idCategory,
        required this.name,
        required this.description,
        required this.price,
        required this.image1,
        required this.image2,
        required this.createdAt,
        required this.updatedAt,
        required this.available,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        idCategory: json["id_category"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image1: json["image1"],
        image2: json["image2"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        available: json["available"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_category": idCategory,
        "name": name,
        "description": description,
        "price": price,
        "image1": image1,
        "image2": image2,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "available": available,
    };
}

class Status {
    int id;
    String name;
    String description;

    Status({
        required this.id,
        required this.name,
        required this.description,
    });

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
