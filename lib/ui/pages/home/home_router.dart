import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/chat.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(
      BuildContext context, List<User> receivers, User me, Chat chat);

  Future<void> onShowCreateGroup(
      BuildContext context, List<User> activeUsers, User me);
}

class HomeRouter implements IHomeRouter {
  final Widget Function(List<User> receivers, User me, Chat chat)
      showMessageThread;

  final Widget Function(List<User> activerUsers, User me) showCreateGroup;

  HomeRouter(
      {@required this.showMessageThread, @required this.showCreateGroup});

  @override
  Future<void> onShowMessageThread(
      BuildContext context, List<User> receivers, User me, Chat chat) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receivers, me, chat),
      ),
    );
  }

  @override
  Future<void> onShowCreateGroup(
      BuildContext context, List<User> activeUsers, User me) async {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => showCreateGroup(activeUsers, me),
    );
  }
}
