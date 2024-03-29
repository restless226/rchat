import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb _rethinkdb = Rethinkdb();
  Connection? _connection;
  ReceiptService? _receiptService;

  setUp(() async {
    _connection = await _rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(_rethinkdb, _connection!);
    _receiptService = ReceiptService(_connection!, _rethinkdb);
  });

  tearDown(() async {
    _receiptService?.dispose();
    await cleanDb(_rethinkdb, _connection!);
  });

  final _user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  /// test to check whether messages are sent successfully or not
  test('sent receipt successfully', () async {
    Receipt _receipt = Receipt(
      recipient: '444',
      messageId: '1234',
      status: ReceiptStatus.delivered,
      timestamp: DateTime.now(),
    );

    final result = await _receiptService!.send(_receipt);
    expect(result, true);
  });

  /// test to check whether receipts are received successfully or not
  test('successfully subscribed and received receipts', () async {
      _receiptService!.receipts(_user).listen(expectAsync1((receipt) {
        expect(receipt.recipient, _user.id);
      }, count: 2)
    );

    /// delivery receipt from _user to _user itself
    Receipt _receipt = Receipt(
      recipient: _user.id,
      messageId: '1234',
      status: ReceiptStatus.delivered,
      timestamp: DateTime.now(),
    );

    /// read receipt from _user to _user itself
    Receipt _anotherReceipt = Receipt(
      recipient: _user.id,
      messageId: '1234',
      status: ReceiptStatus.read,
      timestamp: DateTime.now(),
    );

    await _receiptService?.send(_receipt);
    await _receiptService?.send(_anotherReceipt);
  });

}