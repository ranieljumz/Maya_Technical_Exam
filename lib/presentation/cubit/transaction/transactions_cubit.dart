// lib/presentation/cubit/transactions/transactions_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mayaapp/domain/entities/transaction.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/usecases/get_transactions.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactions getTransactions;

  TransactionsCubit({required this.getTransactions})
    : super(TransactionsInitial());

  Future<void> fetchTransactions(User user) async {
    emit(TransactionsLoading());
    try {
      // 1. Fetch all transactions where the user is either sender or recipient
      final allTransactions = await getTransactions(user.jwt, user.id);

      // --- NEW FILTERING LOGIC IS HERE ---
      // 2. Filter the list to show only the record relevant to the current user's perspective.
      final filteredTransactions = allTransactions.where((transaction) {
        // Condition 1: Keep if it's a DEBIT and I am the SENDER.
        final bool isMyDebit =
            (transaction.type == 'debit' &&
            transaction.senderUsername == user.username);

        // Condition 2: Keep if it's a CREDIT and I am the RECIPIENT.
        final bool isMyCredit =
            (transaction.type == 'credit' &&
            transaction.recipientUsername == user.username);

        // Return true if either condition is met.
        return isMyDebit || isMyCredit;
      }).toList();

      // 3. Emit the final, filtered list to the UI.
      emit(TransactionsLoaded(filteredTransactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }
}
