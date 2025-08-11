import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/presentation/cubit/auth/auth_cubit.dart';
import 'package:mayaapp/presentation/cubit/home/home_cubit.dart';
import 'package:mayaapp/presentation/screen/send_money_screen.dart';
import 'package:mayaapp/presentation/screen/transaction_history_screen.dart';
import 'package:mayaapp/service_locator.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<HomeCubit>()
            ..fetchUserProfile(context.read<AuthCubit>().loggedInUser!),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hello, ${user.username}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthCubit>().logout(),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            sl<HomeCubit>().fetchUserProfile(
              context.read<AuthCubit>().loggedInUser!,
            );
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildBalanceCard(context),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        String balance = '*****';
        if (state is HomeLoaded) {
          final formatCurrency = NumberFormat.currency(
            locale: 'en_PH',
            symbol: '₱',
          );
          balance = state.isBalanceVisible
              ? formatCurrency.format(state.user.balance)
              : '₱ ••••••';
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Balance',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state is HomeLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        balance,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        (state is HomeLoaded && state.isBalanceVisible)
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        if (state is HomeLoaded) {
                          context.read<HomeCubit>().toggleBalanceVisibility();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(
          context,
          icon: Icons.send,
          label: 'Send Money',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SendMoneyScreen()),
            );
          },
        ),
        _actionButton(
          context,
          icon: Icons.history,
          label: 'History',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionHistoryScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.blue[800]),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
