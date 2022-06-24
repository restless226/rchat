import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/colors.dart';
import 'package:my_chat_app/states_management/home/chats_cubit.dart';
import 'package:my_chat_app/states_management/home/home_cubit.dart';
import 'package:my_chat_app/states_management/home/home_state.dart';
import 'package:my_chat_app/states_management/message/message_bloc.dart';
import 'package:my_chat_app/ui/pages/home/home_router.dart';
import 'package:my_chat_app/ui/widgets/home/active/active_users.dart';
import 'package:my_chat_app/ui/widgets/home/chats/chats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/ui/widgets/shared/header_status.dart';
import 'package:my_chat_app/viewmodels/chats_view_model.dart';

class Home extends StatefulWidget {
  final ChatsViewModel viewModel;
  final IHomeRouter router;
  final User me;
  const Home(this.viewModel, this.router, this.me, {Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User _user;
  List<User> _activeUsers = [];

  void _initialSetup() async {
    final user = (!_user.active) ? await context.read<HomeCubit>().connect() : _user;
    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(user);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HeaderStatus(_user.username, _user.photoUrl, true),
          bottom: TabBar(
            indicatorPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('Messages'),
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: BlocBuilder(
                          builder: (BuildContext _, state) {
                            if (state is HomeSuccess) {
                              _activeUsers = state.onlineUsers;
                              return Text("Active(${state.onlineUsers.length})");
                            }

                            return const Text("Active(0)");
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Chats(_user, widget.router),
              ActiveUsers(_user, widget.router),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimary,
          child: const Icon(
            Icons.group_add_rounded,
            color: Colors.white,
          ),
          onPressed: () async {
            await widget.router.onShowCreateGroup(context, _activeUsers, _user);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
