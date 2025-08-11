import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username; // Mobile number
  final String email;
  final double balance;
  final String jwt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.balance,
    this.jwt = '',
  });

  @override
  List<Object?> get props => [id, username, email, balance, jwt];
}
