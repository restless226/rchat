import 'dart:convert';

import 'package:chat/chat.dart';
import 'package:my_chat_app/models/local_message.dart';

class Chat {
  String id;
  int unread = 0;
  List<LocalMessage> messages = [];
  LocalMessage mostRecent;
  User from;
  List<User> members;
  List<Map> membersId;
  String name;

  Chat(this.id, {this.messages, this.mostRecent, this.members, this.membersId, this.name});

  /// from id itself all messages can be fetched associated with that particular chat
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'members': membersId.map((e) => jsonEncode(e)).join(",")
  };

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
      json['id'],
      membersId: List<Map>.from(json['members'].split(",").map((e) => jsonDecode(e))),
      name: json['name'],
  );
}
