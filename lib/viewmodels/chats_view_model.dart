import 'package:chat/chat.dart';
import 'package:my_chat_app/data/datasources/datasource_contract.dart';
import 'package:my_chat_app/models/chat.dart';
import 'package:my_chat_app/models/local_message.dart';
import 'package:my_chat_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  final IDataSource _dataSource;
  final IUserService _userService;

  ChatsViewModel(this._dataSource, this._userService) : super(_dataSource);

  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    await Future.forEach(chats, (Chat chat) async {
      final userIds = chat.membersId.map<String>((e) => e.keys.first).toList();
      final users = await _userService.fetch(userIds);
      chat.members = users;
    });
    return chats;
  }

  Future<void> receiveMessages(Message message) async {
    final chatId = message.groupId ?? message.from;

    /// creating _localMessage object for received message object
    LocalMessage _localMessage = LocalMessage(
      chatId: chatId,
      message: message,
      receipt: ReceiptStatus.delivered,
    );
    await addMessage(_localMessage);
  }
}
