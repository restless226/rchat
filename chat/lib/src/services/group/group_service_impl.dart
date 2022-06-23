import 'dart:async';

import 'package:chat/src/models/message_group.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'group_service_contract.dart';

class MessageGroupService implements IGroupService {
  final Connection _connection;
  final Rethinkdb _rethinkdb;

  final _controller = StreamController<MessageGroup>.broadcast();
  StreamSubscription? _changefeed;

  MessageGroupService(this._rethinkdb, this._connection);

  @override
  Future<MessageGroup> create(MessageGroup group) async {
    Map record = await _rethinkdb
        .table('message_groups')
        .insert(group.toJson(), {'return_changes': true}).run(_connection);

    return MessageGroup.fromJson(record['changes'].first['new_val']);
  }

  @override
  Stream<MessageGroup> groups({@required User? me}) {
    _startReceivingGroups(me!);
    return _controller.stream;
  }

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  _startReceivingGroups(User user) {
    _changefeed = _rethinkdb
        .table('message_groups')
        .filter(
          (group) => group('members')
              .contains(user.id)
              .and(group('created_by').ne(user.id))
              .and(
                group
                    .hasFields('received_by')
                    .not()
                    .or(group('received_by').contains(user.id).not()),
              ),
        )
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;

                final group = _groupFromFeed(feedData);
                _controller.sink.add(group);
                _updateWhenReceivedGroupCreated(group, user);
              })
              .catchError((e) => print(e))
              .onError((error, stackTrace) => print(error));
        });
  }

  MessageGroup _groupFromFeed(feedData) {
    var data = feedData['new_val'];
    return MessageGroup.fromJson(data);
  }

  _updateWhenReceivedGroupCreated(MessageGroup group, User user) async {
    Map updatedRecord =
        await _rethinkdb.table('message_groups').get(group.id).update(
            (group) => _rethinkdb.branch(group.hasFields('received_by'), {
                  'received_by': group('received_by').append(user.id)
                }, {
                  'received_by': [user.id]
                }),
            {'return_changes': 'always'}).run(_connection);
    _removeGroupWhenDeliveredToAll(updatedRecord['changes'][0]);
  }

  _removeGroupWhenDeliveredToAll(Map map) {
    final List members = map['new_val']['members'];
    final List alreadyReceived = map['new_val']['received_by'];
    final String id = map['new_val']['id'];

    if (members.length > alreadyReceived.length) return;

    _rethinkdb
        .table('message_groups')
        .get(id)
        .delete({'return_changes': false}).run(_connection);
  }
}
