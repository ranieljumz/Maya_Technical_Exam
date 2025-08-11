// lib/data/models/transaction_model.dart

import 'package:mayaapp/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.status,
    required super.type,
    required super.senderUsername,
    required super.recipientUsername,
    required super.createdAt,
  });

  // --- REVISED AND CORRECTED fromJson FACTORY ---
  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
    int currentUserId,
  ) {
    // We are no longer looking for a nested 'attributes' object.
    // We work directly with the 'json' map.

    // Safely cast the nested sender and recipient objects.
    final senderObject = json['sender'] as Map<String, dynamic>?;
    final recipientObject = json['recipient'] as Map<String, dynamic>?;

    // The backend is now providing the 'type' directly, which is great!
    // We can rely on this instead of calculating it on the client.
    final String transactionType = json['type'] ?? 'unknown';

    return TransactionModel(
      // Access all fields directly from the top-level 'json' object.
      id: json['id'] ?? 0, // Provide a fallback in case id is null
      amount: (json['amount'] as num? ?? 0).toDouble(),

      // IMPORTANT: The key in the response is 'txnStatus', not 'status'.
      status: json['txnStatus'] ?? 'unknown',

      // Use the reliable type provided by the backend.
      type: transactionType,

      // The sender/recipient objects are also flat, so we access 'username' directly.
      senderUsername: senderObject?['username'] ?? 'Unknown User',
      recipientUsername: recipientObject?['username'] ?? 'Unknown User',

      // Safely parse the 'createdAt' date.
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
