// lib/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mayaapp/data/datasources/remote_data_source.dart';
import 'package:mayaapp/domain/repositories/auth_repository.dart';
import 'package:mayaapp/domain/repositories/auth_repository_impl.dart';
import 'package:mayaapp/domain/repositories/wallet_repository.dart';
import 'package:mayaapp/domain/repositories/wallet_repository_impl.dart';
import 'package:mayaapp/domain/usecases/get_transactions.dart';
import 'package:mayaapp/domain/usecases/get_user_profile.dart';
import 'package:mayaapp/domain/usecases/login_user.dart';
import 'package:mayaapp/domain/usecases/send_money.dart';
import 'package:mayaapp/presentation/cubit/auth/auth_cubit.dart';
import 'package:mayaapp/presentation/cubit/home/home_cubit.dart';
import 'package:mayaapp/presentation/cubit/send_money/send_money_cubit.dart';
import 'package:mayaapp/presentation/cubit/transaction/transactions_cubit.dart';

final sl = GetIt.instance;

void init() {
  // Cubits
  sl.registerFactory(() => AuthCubit(loginUser: sl()));
  sl.registerFactory(() => HomeCubit(getUserProfile: sl()));
  sl.registerFactory(() => SendMoneyCubit(sendMoney: sl()));
  sl.registerFactory(() => TransactionsCubit(getTransactions: sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => SendMoney(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(dio: sl()),
  );

  // External
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        // IMPORTANT: Use your machine's IP, not localhost, for Android emulator
        baseUrl: 'http://localhost:1337/api', // Replace with your IP
      ),
    ),
  );
}
