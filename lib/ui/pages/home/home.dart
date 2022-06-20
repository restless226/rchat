import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/states_management/home/chats_cubit.dart';
import 'package:my_chat_app/states_management/home/home_cubit.dart';
import 'package:my_chat_app/states_management/home/home_state.dart';
import 'package:my_chat_app/states_management/message/message_bloc.dart';
import 'package:my_chat_app/ui/widgets/home/active/active_users.dart';
import 'package:my_chat_app/ui/widgets/home/chats/chats.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().activeUsers();
    context.read<ChatsCubit>().chats();
    final user = User.fromJson({
      'id': '',
      'photoUrl': '',
      'active': true,
      'lastseen': DateTime.now(),
    });
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  const ProfileImage(
                    imageUrl: '',
                    online: true,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'username',
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text('online',
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: BlocBuilder(
                          builder: (BuildContext context, state) {
                            if (state is HomeLoading) {
                              return const Center(child: CircularProgressIndicator.adaptive());
                            }
                            if (state is HomeSuccess) {
                              return Text("Active(${state.onlineUsers.length})");
                            }
                            return const Text("Active(0)");
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: const SafeArea(
            child: TabBarView(
              children: [
                Chats(),
                ActiveUsers(),
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
