// test/presentation/cubit/auth_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/usecases/login_user.dart';
import 'package:mayaapp/presentation/cubit/auth/auth_cubit.dart';

import 'auth_cubit_test.mocks.dart';

// Annotation to generate a mock class for LoginUser.
@GenerateMocks([LoginUser])
void main() {
  late AuthCubit authCubit;
  late MockLoginUser mockLoginUser;

  setUp(() {
    mockLoginUser = MockLoginUser();
    authCubit = AuthCubit(loginUser: mockLoginUser);
  });

  tearDown(() {
    authCubit.close();
  });

  const tUser = User(
    id: 1,
    username: '09171234567',
    email: 'test@test.com',
    balance: 100.0,
    jwt: 'token',
  );
  const tMobile = '09171234567';
  const tPassword = 'password';

  test('initial state should be AuthInitial', () {
    expect(authCubit.state, AuthInitial());
  });

  group('attemptLogin', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        // Arrange
        when(mockLoginUser.call(any, any)).thenAnswer((_) async => tUser);
        return authCubit;
      },
      act: (cubit) => cubit.attemptLogin(tMobile, tPassword),
      expect: () => [AuthLoading(), const AuthAuthenticated(tUser)],
      verify: (_) {
        verify(mockLoginUser.call(tMobile, tPassword));
        verifyNoMoreInteractions(mockLoginUser);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails',
      build: () {
        // Arrange
        when(mockLoginUser.call(any, any)).thenThrow(Exception('Login failed'));
        return authCubit;
      },
      act: (cubit) => cubit.attemptLogin(tMobile, tPassword),
      expect: () => [
        AuthLoading(),
        const AuthError('Login failed. Please check your credentials.'),
      ],
      verify: (_) {
        verify(mockLoginUser.call(tMobile, tPassword));
        verifyNoMoreInteractions(mockLoginUser);
      },
    );
  });
}
