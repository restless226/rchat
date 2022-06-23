import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/colors.dart';
import 'package:my_chat_app/models/chat.dart';
import 'package:my_chat_app/states_management/home/chats_cubit.dart';
import 'package:my_chat_app/states_management/message/message_bloc.dart';
import 'package:my_chat_app/states_management/typing/typing_notification_bloc.dart';
import 'package:my_chat_app/theme.dart';
import 'package:my_chat_app/ui/pages/home/home_router.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';

// ignore: implementation_imports
import 'package:chat/src/models/typing_event_enums.dart';

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
  }

  _buildListView() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: () async {
                await widget.homeRouter.onShowMessageThread(
                  context,
                  chats[index].from,
                  widget.user,
                  chatId: chats[index].id,
                );
                await context.read<ChatsCubit>().chats();
              },
              child: _chatItem(chats[index]),
            ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: chats.length);
  }

  _chatItem(Chat chat) => ListTile(
        contentPadding: const EdgeInsets.only(left: 16.0),
        leading: ProfileImage(
          imageUrl: chat.from.photoUrl,
          online: chat.from.active,
        ),
        title: Text(
          chat.from.username,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
          builder: (_, state) {
            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.start &&
                state.event.from == chat.from.id) {
              this.typingEvents.add(state.event.from);
            }

            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.stop &&
                state.event.from == chat.id) {
              this.typingEvents.removeWhere(
                    (e) => e == state.event.from,
                  );
            }

            if (this.typingEvents.contains(chat.id)) {
              return Text(
                'typing...',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontStyle: FontStyle.italic),
              );
            }

            return Text(
              chat.mostRecent.message.contents,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context).textTheme.overline.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                    fontWeight:
                        chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
            );
          },
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('h:mm a').format(chat.mostRecent.message.timestamp),
              style: Theme.of(context).textTheme.overline.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: chat.unread > 0
                    ? Container(
                        height: 15,
                        width: 15,
                        color: kPrimary,
                        alignment: Alignment.center,
                        child: Text(
                          chat.unread.toString(),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (_, chats) {
      this.chats = chats;
      if (this.chats.isEmpty) return Container();
      context.read<TypingNotificationBloc>().add(
          TypingNotificationEvent.onSubscribed(widget.user,
              usersWithChat: chats.map((e) => e.from.id).toList()));
      return _buildListView();
    });
  }
}
