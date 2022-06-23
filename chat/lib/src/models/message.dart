import 'package:flutter/foundation.dart';

class Message {
  final String? from;  // id of sender user
  final String? to;  // id of receiver user
  final DateTime? timestamp;
  final String? contents;
  String? _messageId;
  String? groupId;

  String? get id => _messageId;

  Message({
    @required this.from,
    @required this.to,
    @required this.timestamp,
    @required this.contents,
    @required this.groupId,
  });

  toJson() => {
    'from': this.from,
    'to': this.to,
    'timestamp': this.timestamp,
    'contents': this.contents,
    'group_id': this.groupId,
  };

  factory Message.fromJson(Map<String, dynamic> json) {
    Message message = Message(
      from: json['from'],
      to: json['to'],
      timestamp: json['timestamp'],
      contents: json['contents'],
      groupId: json['group_id'],
    );
    message._messageId = json['id'];
    return message;
  }

}