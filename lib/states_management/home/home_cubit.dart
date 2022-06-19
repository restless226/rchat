import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:my_chat_app/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final IUserService _userService;

  HomeCubit(this._userService) : super(HomeInitial());

  Future<void> activeUsers() async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }
}
