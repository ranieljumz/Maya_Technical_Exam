import 'package:dio/dio.dart';
import 'package:mayaapp/data/models/transaction_model.dart';
import 'package:mayaapp/data/models/user_model.dart';

import '../../core/error/exceptions.dart';

abstract class RemoteDataSource {
  Future<UserModel> login(String mobileNumber, String password);
  Future<List<TransactionModel>> getTransactions(String token, int userId);
  Future<void> sendMoney(String token, String recipientNumber, double amount);
  Future<UserModel> getUserProfile(String token, int userId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String mobileNumber, String password) async {
    try {
      final response = await dio.post(
        '/auth/local',
        data: {'identifier': mobileNumber, 'password': password},
      );

      // The user object from /auth/local is nested and doesn't have custom fields
      // so we must fetch the full user profile separately.
      if (response.statusCode == 200) {
        final token = response.data['jwt'];
        final userId = response.data['user']['id'];
        return await getUserProfile(token, userId);
      } else {
        // This case is unlikely with Dio but good for safety
        throw ServerException(
          message: 'Login failed with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error']?['message'] ??
          'Login failed. Please check credentials.';
      // THROW OUR CUSTOM EXCEPTION
      throw ServerException(message: errorMessage);
    }
  }

  // Example of updating another method
  @override
  Future<void> sendMoney(
    String token,
    String recipientNumber,
    double amount,
  ) async {
    try {
      await dio.post(
        '/wallet/send',
        data: {'recipientMobile': recipientNumber, 'amount': amount},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error']?['message'] ??
          'An unknown error occurred during the transaction.';
      // THROW OUR CUSTOM EXCEPTION
      throw ServerException(message: errorMessage);
    }
  }

  @override
  Future<UserModel> getUserProfile(String token, int userId) async {
    try {
      final response = await dio.get(
        '/users/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // We need to re-fetch the user with their balance, Strapi's /auth/local doesn't return custom fields
      final fullUserResponse = await dio.get(
        '/users/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (fullUserResponse.statusCode == 200) {
        // Manually construct the JSON for the UserModel factory because the user object is not nested
        final userJson = {'user': fullUserResponse.data};
        return UserModel.fromJson(userJson, token);
      } else {
        throw DioException(
          requestOptions: fullUserResponse.requestOptions,
          message: 'Failed to get user profile',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Network Error');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(
    String token,
    int userId,
  ) async {
    try {
      // This query fetches transactions where the user is EITHER the sender OR the recipient.
      final response = await dio.get(
        '/transactions',
        queryParameters: {
          'populate[sender][fields][0]': 'username',
          'populate[recipient][fields][0]': 'username',
          'filters[\$or][0][sender][id][\$eq]': userId,
          'filters[\$or][1][recipient][id][\$eq]': userId,
          'sort': 'createdAt:desc',
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['data'];
        return results
            .map((json) => TransactionModel.fromJson(json, userId))
            .toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Network Error');
    }
  }
}
