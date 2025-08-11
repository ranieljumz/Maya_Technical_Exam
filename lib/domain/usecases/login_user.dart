import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call(String mobileNumber, String password) {
    return repository.login(mobileNumber, password);
  }
}
