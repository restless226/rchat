import 'dart:async';

import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/colors.dart';
import 'package:my_chat_app/models/chat.dart';
import 'package:my_chat_app/models/local_message.dart';
import 'package:my_chat_app/states_management/home/chats_cubit.dart';
import 'package:my_chat_app/states_management/message/message_bloc.dart';
import 'package:my_chat_app/states_management/message_thread/message_thread_cubit.dart';
import 'package:my_chat_app/states_management/receipt/receipt_bloc.dart';
import 'package:my_chat_app/states_management/typing/typing_notification_bloc.dart';
import 'package:my_chat_app/theme.dart';
import 'package:my_chat_app/ui/widgets/shared/header_status.dart';

class MessageThread extends StatefulWidget {
  final User receiver;
  final User me;
  final String chatId;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;

  const MessageThread(this.receiver, this.me, this.chatId, this.messageBloc,
      this.typingNotificationBloc, this.chatsCubit,
      {Key key})
      : super(key: key);

  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  String chatId = '';
  User receiver;
  StreamSubscription _subscription;
  List<LocalMessage> messages = [];
  Timer _startTypingTimer;
  Timer _stopTypingTimer;

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) messageThreadCubit.messages(chatId);
    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await messageThreadCubit.viewModel.receivedMessage(state.message);
        final receipt = Receipt(
          recipient: state.message.from,
          messageId: state.message.id,
          status: ReceiptStatus.read,
          timestamp: DateTime.now(),
        );
        context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
      }
      if (state is MessageSentSuccess) {
        await messageThreadCubit.viewModel.sentMessage(state.message);
        widget.chatsCubit.chats();
      }
      if (chatId.isEmpty) chatId = messageThreadCubit.viewModel.chatId;
      messageThreadCubit.messages(chatId);
    });
  }

  void _updateOnReceiptReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.viewModel.updateMessageReceipt(state.receipt);
        messageThreadCubit.messages(chatId);
        widget.chatsCubit.chats();
      }
    });
  }

  _buildMessageInput(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(90.0)),
      borderSide: isLightTheme(context)
          ? BorderSide.none
          : BorderSide(color: Colors.grey.withOpacity(0.3)),
    );
    return Focus(
      onFocusChange: (focus) {
        if (_startTypingTimer == null || (_startTypingTimer != null && focus)) {
          return;
        }
        _stopTypingTimer?.cancel();
      },
      child: TextFormField(
        controller: _textEditingController,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: Theme.of(context).textTheme.caption,
        cursorColor: kPrimary,
        onChanged: null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          enabledBorder: _border,
          filled: true,
          fillColor:
              isLightTheme(context) ? kPrimary.withOpacity(0.1) : kBubbleDark,
          focusedBorder: _border,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    receiver = widget.receiver;
    _updateOnMessageReceived();
    _updateOnReceiptReceived();
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.me));
    widget.typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(
      widget.me,
      usersWithChat: [receiver.id],
    ));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _subscription?.cancel();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: isLightTheme(context) ? Colors.black : Colors.white,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            Expanded(
              child: HeaderStatus(
                username: receiver.username,
                imageUrl: receiver.photoUrl,
                online: receiver.active,
                lastSeen: receiver.lastseen,
                typing: false,
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Flexible(
                flex: 6,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isLightTheme(context) ? Colors.white : kAppBarDark,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, -3),
                          blurRadius: 6.0,
                          color: Colors.black12,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildMessageInput(context)),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            height: 45.0,
                            width: 45.0,
                            child: RawMaterialButton(
                                fillColor: kPrimary,
                                shape: const CircleBorder(),
                                elevation: 5.0,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
