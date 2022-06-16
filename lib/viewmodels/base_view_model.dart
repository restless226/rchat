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

  Future<void> _createNewChat(String chatId) async {
    final Chat _chat = Chat(chatId);
    await _dataSource.addChat(_chat);
  }

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!(await _isExistingChat(message.chatId))) {
      await _createNewChat(message.chatId);
    }
    await _dataSource.addMessage(message);
  }
}
