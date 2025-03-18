class UserModel {
  late String name;
  late String phone;
  late String email;
  late String password;
  late String image;
  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.image,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
  }
  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'image': image,
      };
}
