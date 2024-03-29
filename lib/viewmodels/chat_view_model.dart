import 'package:chat/chat.dart';
import 'package:my_chat_app/data/datasources/datasource_contract.dart';
import 'package:my_chat_app/models/local_message.dart';

import 'base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  final IDataSource _dataSource;
  String _chatId = '';
  int otherMessages = 0;

  /// used as an indicator to show you have x no of new messages notification

  ChatViewModel(this._dataSource) : super(_dataSource);

  String get chatId => _chatId;

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    final chatId = message.groupId ?? message.from;
    LocalMessage _localMessage = LocalMessage(
      chatId: chatId,
      message: message,
      receipt: ReceiptStatus.sent,
    );
    if (_chatId.isNotEmpty) return await _dataSource.addMessage(_localMessage);
    _chatId = _localMessage.chatId;
    await addMessage(_localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    final chatId = message.groupId ?? message.from;
    LocalMessage _localMessage = LocalMessage(
      chatId: chatId,
      message: message,
      receipt: ReceiptStatus.delivered,
    );
    if (_chatId.isEmpty) _chatId = _localMessage.chatId;
    if (_localMessage.chatId != _chatId) otherMessages++;
    await addMessage(_localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _dataSource.updateMessageReceipt(receipt.messageId, receipt.status);
  }
}
