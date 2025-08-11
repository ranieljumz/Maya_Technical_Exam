import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mayaapp/domain/entities/user.dart';
import 'package:mayaapp/domain/usecases/get_user_profile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetUserProfile getUserProfile;

  HomeCubit({required this.getUserProfile}) : super(HomeInitial());

  Future<void> fetchUserProfile(User currentUser) async {
    emit(HomeLoading());
    try {
      final user = await getUserProfile(currentUser.jwt, currentUser.id);
      emit(HomeLoaded(user: user));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void toggleBalanceVisibility() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        HomeLoaded(
          user: currentState.user,
          isBalanceVisible: !currentState.isBalanceVisible,
        ),
      );
    }
  }
}
