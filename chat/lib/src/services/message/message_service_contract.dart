import 'package:chat/src/models/message.dart';
import 'package:flutter/cupertino.dart';

abstract class IMessageService {
  Future<bool> send(Message message);   // return true if message is sent

  Future<Stream<Message>> messages({@required activeUser});   // get messages from a particular user

  dispose();
}