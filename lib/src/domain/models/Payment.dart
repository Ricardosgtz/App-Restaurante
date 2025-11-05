import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  int id;
  String paymentMethod;
  String status;
  double amount;
  String? receipt;
  String paymentDate;

  Payment({
    required this.id,
    required this.paymentMethod,
    required this.status,
    required this.amount,
    this.receipt,
    required this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        amount: double.tryParse(json["amount"].toString()) ?? 0.0,
        receipt: json["receipt"],
        paymentDate: json["payment_date"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_method": paymentMethod,
        "status": status,
        "amount": amount,
        "receipt": receipt,
        "payment_date": paymentDate,
      };
}
