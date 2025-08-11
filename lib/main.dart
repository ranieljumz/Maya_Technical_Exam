// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayaapp/presentation/cubit/auth/auth_cubit.dart';
import 'package:mayaapp/presentation/screen/home_screen.dart';
import 'package:mayaapp/presentation/screen/login_screen.dart';
import 'service_locator.dart' as di;

void main() {
  di.init(); // Initialize dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthCubit>(),
      child: MaterialApp(
        title: 'MayaApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.grey[800]),
            titleTextStyle: TextStyle(
              color: Colors.grey[800],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return HomeScreen(user: state.user);
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
