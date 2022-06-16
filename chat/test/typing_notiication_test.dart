import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/typing_event_enums.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:chat/src/services/typing_notification/typing_notification_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb _rethinkdb = Rethinkdb();
  Connection? _connection;
  TypingNotificationService? _typingNotificationService;

  setUp(() async {
    _connection = await _rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(_rethinkdb, _connection!);
    _typingNotificationService = TypingNotificationService(_connection!, _rethinkdb);
  });

  tearDown(() async {
    _typingNotificationService?.dispose();
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
  
  test('sent typing notification successfully', () async {
    TypingEvent _typingEvent = TypingEvent(
      from: _user1.id,
      to: _user2.id,
      event: Typing.start,
    );

    final result = await _typingNotificationService?.send(typingEvent: _typingEvent, to: _user2);
    expect(result, true);
  });

  test('successfully subscribed and received typing events', () async {
      _typingNotificationService!.subscribe(_user2, [_user1.id!]).listen(expectAsync1((event) {
          expect(event.from, _user1.id);
        }, count: 2,
      )
    );

    TypingEvent _startEvent = TypingEvent(
        from: _user2.id,
        to: _user1.id,
        event: Typing.start,
    );

    TypingEvent _stopEvent = TypingEvent(
      from: _user2.id,
      to: _user1.id,
      event: Typing.stop,
    );

    await _typingNotificationService?.send(typingEvent: _startEvent, to: _user2);
    await _typingNotificationService?.send(typingEvent: _stopEvent, to: _user2);
  });
}
