import 'package:chat/src/models/message_group.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IGroupService {
  Future<MessageGroup> create(MessageGroup group);

  Stream<MessageGroup> groups({@required User me});

  dispose();
}
