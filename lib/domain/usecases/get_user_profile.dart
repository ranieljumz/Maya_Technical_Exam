import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/repositories/wallet_repository.dart';

class GetUserProfile {
  final WalletRepository repository;

  GetUserProfile(this.repository);

  Future<User> call(String token, int userId) {
    return repository.getUserProfile(token, userId);
  }
}
