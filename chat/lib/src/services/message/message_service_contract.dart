import 'package:chat/src/models/message.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user.dart';

abstract class IMessageService {
  Future<bool> send(Message message);   // return true if message is sent

  Stream<Message> messages({@required User activeUser});   // get messages from a particular user

  dispose();    // to dispose _controller and _changeFeed
}