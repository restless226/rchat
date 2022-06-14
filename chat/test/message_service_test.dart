import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb _rethinkdb = Rethinkdb();
  Connection? _connection;
  MessageService? _messageService;

  setUp(() async {
    _connection = await _rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(_rethinkdb, _connection!);
    _messageService = MessageService(_connection!, _rethinkdb);
  });

  tearDown(() async {
    _messageService?.dispose();
    await cleanDb(_rethinkdb, _connection!);
  });

  final _user1 = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  final _user2 = User.fromJson({
    'id': '1111',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  /// test to check whether messages are sent successfully or not
  test('sent message successfully', () async {
    Message _message = Message(
      from: _user1.id,
      to: '3456',
      timestamp: DateTime.now(),
      contents: 'this is a test message sent from user1 to 3456',
    );

    final result = await _messageService!.send(_message);
    expect(result, true);
  });

  /// test to check whether messages are received successfully or not
  test('successfully subscribed and received messages', () async {
      _messageService!.messages(activeUser: _user2).listen(expectAsync1((message) {
        expect(message.to, _user2.id);
        expect(message.id, isNotEmpty);
      }, count: 2)
    );

    Message _message = Message(
      from: _user1.id,
      to: _user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a test message sent from user1 to user2',
    );

    Message _anotherMessage = Message(
      from: _user1.id,
      to: _user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a another message sent from user1 to user2',
    );

    await _messageService?.send(_message);
    await _messageService?.send(_anotherMessage);
  });

  /// test to check whether new messages are received successfully or not
  test('successfully subscribe and received new messages', () async {
    Message _message = Message(
      from: _user1.id,
      to: _user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a test message sent from user1 to user2',
    );

    Message _anotherMessage = Message(
      from: _user1.id,
      to: _user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a another message sent from user1 to user2',
    );

    await _messageService?.send(_message);

    // subscribing after _anotherMessage is sent
    await _messageService?.send(_anotherMessage).whenComplete(
          () => _messageService!.messages(activeUser: _user2).listen(
              expectAsync1((message) {
                expect(message.to, _user2.id);
          }, count: 2),
        )
    );
  });

}
