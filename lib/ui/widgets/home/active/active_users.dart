import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/states_management/home/home_cubit.dart';
import 'package:my_chat_app/states_management/home/home_state.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';

class ActiveUsers extends StatefulWidget {
  const ActiveUsers({Key key}) : super(key: key);

  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  _listItem(User user) => ListTile(
        leading: ProfileImage(
          imageUrl: user.photoUrl,
          online: true,
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.caption.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
        padding: const EdgeInsets.only(top: 30, right: 16),
        itemBuilder: (BuildContext context, index) => GestureDetector(
          child: _listItem(users[index]),
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: users.length,
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
      if (state is HomeLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      if (state is HomeSuccess) {
        return _buildList(state.onlineUsers);
      }
      return Container();
    });
  }
}
