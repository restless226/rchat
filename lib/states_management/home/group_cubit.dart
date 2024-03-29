import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';

class GroupCubit extends Cubit<List<User>> {
  GroupCubit() : super([]);

  void add(User user) {
    state.add(user);
    emit(List.from(state));
  }

  void remove(User user) {
    state.removeWhere((ele) => ele.id == user.id);
    emit(List.from(state));
  }
}
