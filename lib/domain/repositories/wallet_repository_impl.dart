import 'package:mayaapp/data/datasources/remote_data_source.dart';
import 'package:mayaapp/domain/entities/transaction.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final RemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getUserProfile(String token, int userId) async {
    return await remoteDataSource.getUserProfile(token, userId);
  }

  @override
  Future<List<Transaction>> getTransactions(String token, int userId) async {
    return await remoteDataSource.getTransactions(token, userId);
  }

  @override
  Future<void> sendMoney(
    String token,
    String recipientNumber,
    double amount,
  ) async {
    return await remoteDataSource.sendMoney(token, recipientNumber, amount);
  }
}
