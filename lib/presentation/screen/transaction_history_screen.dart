import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mayaapp/domain/entities/transaction.dart' as T;
import 'package:mayaapp/presentation/cubit/auth/auth_cubit.dart';
import 'package:mayaapp/presentation/cubit/transaction/transactions_cubit.dart';
import 'package:mayaapp/service_locator.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TransactionsCubit>()
            ..fetchTransactions(context.read<AuthCubit>().loggedInUser!),
      child: Scaffold(
        appBar: AppBar(title: const Text('Transaction History')),
        body: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            if (state is TransactionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TransactionsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            }
            if (state is TransactionsLoaded) {
              if (state.transactions.isEmpty) {
                return const Center(
                  child: Text(
                    'No transactions yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.transactions.length,
                itemBuilder: (ctx, index) {
                  final transaction = state.transactions[index];
                  return _buildTransactionItem(transaction);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildTransactionItem(T.Transaction transaction) {
    final bool isDebit = transaction.type == 'debit';
    final formatCurrency = NumberFormat.currency(locale: 'en_PH', symbol: '₱');
    final formatDate = DateFormat('MMM dd, yyyy hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDebit ? Colors.red[100] : Colors.green[100],
          child: Icon(
            isDebit ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebit ? Colors.red[700] : Colors.green[700],
          ),
        ),
        title: Text(
          isDebit
              ? 'Sent to ${transaction.recipientUsername}'
              : 'Received from ${transaction.senderUsername}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formatDate.format(transaction.createdAt)),
        trailing: Text(
          '${isDebit ? '-' : '+'} ${formatCurrency.format(transaction.amount)}',
          style: TextStyle(
            color: isDebit ? Colors.red[700] : Colors.green[700],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
