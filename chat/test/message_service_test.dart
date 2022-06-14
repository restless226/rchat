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
      contents: 'this is a test message sent from user1 to user2',
    );

    final result = await _messageService!.send(_message);
    expect(result, true);
  });
}
