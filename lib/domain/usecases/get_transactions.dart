import 'package:mayaapp/domain/entities/transaction.dart';
import 'package:mayaapp/domain/repositories/wallet_repository.dart';

class GetTransactions {
  final WalletRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call(String token, int userId) {
    return repository.getTransactions(token, userId);
  }
}
