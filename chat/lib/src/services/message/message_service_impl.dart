import 'dart:async';

import 'package:chat/src/models/message.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import '../../models/user.dart';

class MessageService implements IMessageService {

  final Connection _connection;
  final Rethinkdb _rethinkdb;

  /// broadcast stream can be subscribed by multiple clients
  /// whereas regular stream can be subscribed only by a single client after which it will be closed
  final _controller = StreamController<Message>.broadcast();

  StreamSubscription? _changeFeed;

  MessageService(this._connection, this._rethinkdb);

  @override
  dispose() {
    _controller.close();
    _changeFeed?.cancel();
  }

  Message _extractMessageFromFeed(feedData) {
    final Message _message = Message.fromJson(feedData['new_val']);
    return _message;
  }

  /// as soon as the message is delivered then it is removed from the server,
  /// so all your messages are stored locally on device
  _removeMessage(Message _message) {
    _rethinkdb
        .table('messages')
        .get(_message.id)
        .delete({'return_changes': false})
        .run(_connection);
  }

  /// stream consumes memory space hence it is not a good idea
  /// to start a steam a without anybody subscribed to it
  /// this method activates a stream when an user triggers it
  _startReceivingMessages(User _activeUser) {
    /// "include_initial" will add initial changes in _changeFeed
    /// it means if you are just subscribing to _changeFeed but there are messages waiting on queue for you
    /// then you will immediately get those messages
    _changeFeed = _rethinkdb
        .table('messages')
        .filter({'to': _activeUser.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          // fetching actual message data from feed event
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final Message _message = _extractMessageFromFeed(feedData);
            _controller.sink.add(_message);
            _removeMessage(_message);
          })
          .catchError((error) => print("feedData event error = " + error.toString()))
          .onError((error, stackTrace) => print("stackTrace = " + error.toString()));
        });
  }

  @override
  Stream<Message> messages({User? activeUser}) {
    _startReceivingMessages(activeUser!);
    return _controller.stream;
  }

  @override
  Future<bool> send(Message message) async {
    var data = message.toJson();

    Map record = await _rethinkdb
        .table('messages')
        .insert(data)
        .run(_connection);

    return record['inserted'] == 1;
  }

}