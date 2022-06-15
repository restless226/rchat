import 'package:flutter/foundation.dart';

enum ReceiptStatus {
  sent,
  delivered,
  read,
}

extension EnumParsing on ReceiptStatus {
  String value() {
    return this.toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class Receipt {
  final String? recipient;
  final String? messageId;
  final ReceiptStatus? status;
  final DateTime? timestamp;
  String? _receiptId;

  String? get id => _receiptId;

  Receipt({
    @required this.recipient,
    @required this.messageId,
    @required this.status,
    @required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'recipient': this.recipient,
    'messageId': this.messageId,
    'status': status?.value(),
    'timestamp': timestamp,
  };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    Receipt receipt = Receipt(
      recipient: json['recipient'],
      messageId: json['messageId'],
      status: EnumParsing.fromString(json['status']),
      timestamp: json['timestamp'],
    );
    receipt._receiptId = json['id'];
    return receipt;
  }
}
