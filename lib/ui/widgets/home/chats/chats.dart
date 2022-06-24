import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/colors.dart';
import 'package:my_chat_app/models/chat.dart';
import 'package:my_chat_app/states_management/home/chats_cubit.dart';
import 'package:my_chat_app/states_management/message/message_bloc.dart';
import 'package:my_chat_app/states_management/message_group/message_group_bloc.dart';
import 'package:my_chat_app/states_management/typing/typing_notification_bloc.dart';
import 'package:my_chat_app/theme.dart';
import 'package:my_chat_app/ui/pages/home/home_router.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';

// ignore: implementation_imports
import 'package:chat/src/models/typing_event_enums.dart';
import 'package:my_chat_app/utils/color_generator.dart';

class Chats extends StatefulWidget {
  final User user;
  final IHomeRouter homeRouter;

  const Chats(this.user, this.homeRouter, {Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var chats = [];
  final typingEvents = [];

  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().chats();
  }

  void _updateChatsOnMessageReceived() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.viewModel.receiveMessages(state.message);
        chatsCubit.chats();
      }
    });

    context.read<MessageGroupBloc>().stream.listen((state) async {
      if (state is MessageGroupReceived) {
        final group = state.group;
        group.members.removeWhere((e) => e == widget.user.id);
        final membersId = group.members
            .map((e) => {e: RandomColorGenerator.getColor().value.toString()})
            .toList();
        final chat = Chat(group.id, ChatType.group,
            name: group.name, membersId: membersId);
        await chatsCubit.viewModel.createNewChat(chat);
        chatsCubit.chats();
      }
    });
  }

  _buildListView() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: () async {
                await widget.homeRouter.onShowMessageThread(
                  context,
                  chats[index].members,
                  widget.user,
                  chats[index],
                );
                await context.read<ChatsCubit>().chats();
              },
              child: _chatItem(chats[index]),
            ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: chats.length);
  }

  _chatItem(Chat chat) => ListTile(
        leading: ProfileImage(
          imageUrl: chat.type == ChatType.individual
              ? chat.members.first.photoUrl
              : null,
          online: chat.type == ChatType.individual
              ? chat.members.first.active
              : false,
        ),
        title: Text(
          chat.type == ChatType.individual
              ? chat.members.first.username
              : chat.name,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
            builder: (__, state) {
          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.chatId == chat.id)
            this.typingEvents.add(state.event.chatId);

          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.chatId == chat.id)
            this.typingEvents.removeWhere((e) => e == state.event.chatId);

          if (this.typingEvents.contains(chat.id)) {
            switch (chat.type) {
              case ChatType.group:
                final st = state as TypingNotificationReceivedSuccess;
                final username = chat.members
                    .firstWhere((e) => e.id == st.event.from)
                    .username;
                return Text('$username is typing...',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontStyle: FontStyle.italic));
                break;
              default:
                return Text('typing...',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontStyle: FontStyle.italic));
            }
          }

          return Text(
            chat.mostRecent != null
                ? chat.type == ChatType.individual
                    ? chat.mostRecent.message.contents
                    : (chat.members
                                .firstWhere(
                                    (e) => e.id == chat.mostRecent.message.from,
                                    orElse: () => null)
                                ?.username ??
                            'You') +
                        ': ' +
                        chat.mostRecent.message.contents
                : 'Group created',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.overline.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70,
                fontWeight:
                    chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
          );
        }),
        contentPadding: const EdgeInsets.only(left: 16.0),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (chat.mostRecent != null)
                Text(
                  DateFormat('h:mm a')
                      .format(chat.mostRecent.message.timestamp),
                  style: Theme.of(context).textTheme.overline.copyWith(
                      color: isLightTheme(context)
                          ? Colors.black54
                          : Colors.white70),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: chat.unread > 0
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Container(
                          height: 15.0,
                          width: 15.0,
                          color: kPrimary,
                          alignment: Alignment.center,
                          child: Text(
                            chat.unread.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (_, chats) {
      this.chats = chats;
      if (this.chats.isEmpty) return Container();
      List<String> userIds = [];
      for (var chat in chats) {
        userIds += chat.members.map((e) => e.id).toList();
      }
      context.read<TypingNotificationBloc>().add(
          TypingNotificationEvent.onSubscribed(widget.user,
              usersWithChat: userIds.toSet().toList()));
      return _buildListView();
    });
  }
}
