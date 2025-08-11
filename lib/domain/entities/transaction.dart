import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int id;
  final double amount;
  final String status;
  final String type; // 'debit' or 'credit'
  final String senderUsername;
  final String recipientUsername;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.status,
    required this.type,
    required this.senderUsername,
    required this.recipientUsername,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, amount, status, type, createdAt];
}
