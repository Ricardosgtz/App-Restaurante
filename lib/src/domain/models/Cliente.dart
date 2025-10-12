class Cliente {
    int? id;
    String name;
    String lastname;
    String? email;
    String phone;
    String? password;
    String? image;

    Cliente({
        this.id,
        required this.name,
        required this.lastname,
        this.email,
        required this.phone, 
        this.password, 
        this.image,
    });

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "image": image,
        "password": password,
    };
}