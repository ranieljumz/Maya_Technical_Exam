import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/usecases/send_money.dart';

part 'send_money_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  final SendMoney sendMoney;

  SendMoneyCubit({required this.sendMoney}) : super(SendMoneyInitial());

  Future<void> executeSendMoney(
    User sender,
    String recipientNumber,
    double amount,
  ) async {
    emit(SendMoneyLoading());
    try {
      await sendMoney(
        token: sender.jwt,
        recipientNumber: recipientNumber,
        amount: amount,
      );
      emit(SendMoneySuccess());
    } catch (e) {
      emit(SendMoneyFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
