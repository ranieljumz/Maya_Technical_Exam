import 'package:mayaapp/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String mobileNumber, String password);
}
