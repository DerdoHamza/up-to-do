class UserModel {
  late String name;
  late String phone;
  late String email;
  late String password;
  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
  }
  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      };
}
