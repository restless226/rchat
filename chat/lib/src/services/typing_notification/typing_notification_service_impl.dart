import 'dart:async';

import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing_notification/typing_notification_service_contract.dart';
import 'package:flutter/foundation.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class TypingNotificationService implements ITypingNotification {

  final Connection _connection;
  final Rethinkdb _rethinkdb;
  final _controller = StreamController<TypingEvent>.broadcast();

  StreamSubscription? _changeFeed;

  TypingNotificationService(this._connection, this._rethinkdb);

  TypingEvent _extractTypingEventFromFeed(feedData) {
    return TypingEvent.fromJson(feedData['new_val']);
  }

  _removeTypingEvent(TypingEvent _typingEvent) {
    _rethinkdb
        .table('typing_events')
        .get(_typingEvent.id)
        .delete({'return_changes': false})
        .run(_connection);
  }

  _startReceivingTypingEvents(User _user, List<String> _userIds) {
    _changeFeed = _rethinkdb
        .table('typing_events')
        .filter((event) {
          return event('to')
              .eq(_user.id)
              .and(_rethinkdb.expr(_userIds).contains(event('from')));
        })
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
      // fetching actual typing event data from feed event
      event.forEach((feedData) {
        if (feedData['new_val'] == null) return;
        final TypingEvent _typingEvent = _extractTypingEventFromFeed(feedData);
        _controller.sink.add(_typingEvent);
        _removeTypingEvent(_typingEvent);
      })
      .catchError((error) => print("feedData event error = " + error.toString()))
      .onError((error, stackTrace) => print("stackTrace = " + error.toString()));
    });
  }

  @override
  Future<bool> send({@required TypingEvent? typingEvent, @required User? to}) async {
   if (to?.active == false) return false;

   var data = typingEvent?.toJson();

   Map record = await _rethinkdb
       .table('typing_events')
       .insert(data, {'conflict': 'update'})
       .run(_connection);

   return record['inserted'] == 1;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingTypingEvents(user, userIds);
    return _controller.stream;
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
    await _changeFeed?.cancel();
  }

}