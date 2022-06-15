import 'dart:async';

import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class ReceiptService implements IReceiptService {

  final Connection _connection;
  final Rethinkdb _rethinkdb;

  /// broadcast stream can be subscribed by multiple clients
  /// whereas regular stream can be subscribed only by a single client after which it will be closed
  final _controller = StreamController<Receipt>.broadcast();

  StreamSubscription? _changeFeed;

  ReceiptService(this._connection, this._rethinkdb);

  @override
  void dispose() {
    _controller.close();
    _changeFeed?.cancel();
  }

  Receipt _extractReceiptFromFeed(feedData) {
    var data = feedData['new_val'];
    final Receipt _receipt = Receipt.fromJson(data);
    return _receipt;
  }

  /// stream consumes memory space hence it is not a good idea
  /// to start a steam a without anybody subscribed to it
  /// this method activates a stream when an user triggers it
  _startReceivingReceipts(User _user) {
    /// "include_initial" will add initial changes in _changeFeed
    /// it means if you are just subscribing to _changeFeed but there are receipts waiting on queue for you
    /// then you will immediately get those receipts
    _changeFeed = _rethinkdb
        .table('receipts')
        .filter({'recipient': _user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
      // fetching actual receipt data from feed event
      event.forEach((feedData) {
        if (feedData['new_val'] == null) return;
        final Receipt _receipt = _extractReceiptFromFeed(feedData);
        _controller.sink.add(_receipt);
      })
      .catchError((error) => print("feedData event error = " + error.toString()))
      .onError((error, stackTrace) => print("stackTrace = " + error.toString()));
    });
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    var data = receipt.toJson();

    Map record = await _rethinkdb
        .table('receipts')
        .insert(data)
        .run(_connection);

    return record['inserted'] == 1;
  }

}