import 'package:mayaapp/domain/repositories/wallet_repository.dart';

class SendMoney {
  final WalletRepository repository;

  SendMoney(this.repository);

  Future<void> call({
    required String token,
    required String recipientNumber,
    required double amount,
  }) {
    return repository.sendMoney(token, recipientNumber, amount);
  }
}
