import 'package:mayaapp/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.balance,
    required String token,
  }) : super(jwt: token);

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['user']['id'],
      username: json['user']['username'],
      email: json['user']['email'],
      balance: (json['user']['balance'] as num).toDouble(),
      token: token,
    );
  }
}
