part of 'send_money_cubit.dart';

abstract class SendMoneyState extends Equatable {
  const SendMoneyState();
  @override
  List<Object> get props => [];
}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

class SendMoneySuccess extends SendMoneyState {}

class SendMoneyFailure extends SendMoneyState {
  final String message;
  const SendMoneyFailure(this.message);
  @override
  List<Object> get props => [message];
}
