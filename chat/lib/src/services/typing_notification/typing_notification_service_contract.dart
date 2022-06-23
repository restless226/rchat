import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class ITypingNotification {
  Future<bool> send({@required List<TypingEvent>? typingEvents});

  Stream<TypingEvent> subscribe(User user, List<String> userIds);

  Future<void> dispose();
}