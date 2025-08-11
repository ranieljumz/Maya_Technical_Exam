// lib/data/repositories/auth_repository_impl.dart

import 'package:mayaapp/core/error/exceptions.dart'; // You can create custom exceptions
import 'package:mayaapp/data/datasources/remote_data_source.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String mobileNumber, String password) async {
    try {
      // The remoteDataSource returns a UserModel. Since UserModel extends User,
      // we can return it directly as it fulfills the contract of the domain entity.
      final userModel = await remoteDataSource.login(mobileNumber, password);
      return userModel;
    } on ServerException catch (e) {
      // In a more complex app, you might catch specific exceptions
      // from the data source and rethrow them as domain-specific failures.
      throw Exception(e.message);
    } catch (e) {
      // For any other generic error.
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
