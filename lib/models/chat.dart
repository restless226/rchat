import 'dart:convert';

import 'package:chat/chat.dart';
import 'package:my_chat_app/models/local_message.dart';

enum ChatType {individual, group}

extension EnumParsing on ChatType {
  String value() {
    return this.toString().split('.').last;
  }

  static ChatType fromString(String status) {
    return ChatType.values.firstWhere((element) => element.value() == status);
  }
}

class Chat {
  String id;
  ChatType type;
  int unread = 0;
  List<LocalMessage> messages = [];
  LocalMessage mostRecent;
  List<User> members;
  List<Map> membersId;
  String name;

  Chat(this.id, this.type, {this.messages, this.mostRecent, this.members, this.membersId, this.name});

  /// from id itself all messages can be fetched associated with that particular chat
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type.value(),
    'members': membersId.map((e) => jsonEncode(e)).join(",")
  };

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
      json['id'],
      EnumParsing.fromString(json['type']),
      membersId: List<Map>.from(json['members'].split(",").map((e) => jsonDecode(e))),
      name: json['name'],
  );
}
