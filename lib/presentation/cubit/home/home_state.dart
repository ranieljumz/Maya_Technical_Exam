part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final User user;
  final bool isBalanceVisible;
  const HomeLoaded({required this.user, this.isBalanceVisible = false});

  @override
  List<Object> get props => [user, isBalanceVisible];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object> get props => [message];
}
