import 'package:chat/chat.dart';

/// this class will represent local messages stored on user's device
/// not that it is separate from chat module

class LocalMessage {
  String chatId;
  String _id;
  Message message;
  ReceiptStatus receipt;

  String get id => _id;

  LocalMessage({this.chatId, this.message, this.receipt});

  Map<String, dynamic> toMap() => {
    'chat_id': chatId,
    'id': _id,
    'sender': message.from,
    'receiver': message.to,
    'contents': message.contents,
    'receipt': receipt?.value(),
    'received_at': message.timestamp.toString(),
  };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final Message _message = Message(
        from: json['sender'],
        to: json['receiver'],
        timestamp: DateTime.parse(json['received_at']),
        contents: json['contents'],
    );

    final LocalMessage _localMessage = LocalMessage(
        chatId: json['chat_id'],
        message: _message,
        receipt: json['receipt'],
    );
    _localMessage._id = json['id'];

    return _localMessage;
  }
}