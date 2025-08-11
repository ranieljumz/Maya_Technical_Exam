import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/usecases/login_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  User? loggedInUser;

  AuthCubit({required this.loginUser}) : super(AuthInitial());

  Future<void> attemptLogin(String mobileNumber, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUser(mobileNumber, password);
      loggedInUser = user;
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(const AuthError('Login failed. Please check your credentials.'));
    }
  }

  void logout() {
    loggedInUser = null;
    emit(AuthInitial());
  }
}
