import 'package:flutter/foundation.dart';
import 'package:my_chat_app/data/datasources/datasource_contract.dart';
import 'package:my_chat_app/models/chat.dart';
import 'package:my_chat_app/models/local_message.dart';

abstract class BaseViewModel {
  final IDataSource _dataSource;

  BaseViewModel(this._dataSource);

  Future<bool> _isExistingChat(String chatId) async {
    Chat _chat = await _dataSource.findChat(chatId);
    return _chat != null;
  }

  Future<void> createNewChat(Chat chat) async {
    await _dataSource.addChat(chat);
  }

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId)) {
      final chat = Chat(message.chatId, ChatType.individual, membersId: [
        {message.chatId: ""}
      ]);
      await createNewChat(chat);
    }
    await _dataSource.addMessage(message);
  }
}
