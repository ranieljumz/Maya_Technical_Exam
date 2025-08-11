import 'package:mayaapp/domain/entities/transaction.dart';
import 'package:mayaapp/domain/entities/user.dart';

abstract class WalletRepository {
  Future<User> getUserProfile(String token, int userId);
  Future<List<Transaction>> getTransactions(String token, int userId);
  Future<void> sendMoney(String token, String recipientNumber, double amount);
}
