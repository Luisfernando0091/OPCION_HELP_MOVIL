// ignore: file_names
class UserModel {
  final int id;
  final String name;
  final String lastName;
  final String email;
  // final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    // required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      lastName: json['LastName'],
      email: json['email'],
      // password: json['password'],
    );
  }
}
