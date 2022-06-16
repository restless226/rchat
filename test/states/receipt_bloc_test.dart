// import 'package:chat/chat.dart';
// import 'package:my_chat_app/states_management/receipt/receipt_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// class FakeReceiptService extends Mock implements IReceiptService {}
//
// void main() {
//   ReceiptBloc _receiptBloc;
//   IReceiptService receiptService;
//   User user;
//
//   setUp(() {
//     receiptService = FakeReceiptService();
//     user = User(
//       username: 'test',
//       photoUrl: '',
//       active: true,
//       lastseen: DateTime.now(),
//     );
//     _receiptBloc = ReceiptBloc(receiptService);
//   });
//
//   tearDown(() => _receiptBloc.close());
//
//   test('should emit initial state only without subscriptions', () {
//     expect(_receiptBloc.state, ReceiptInitial());
//   });
//
//   test('should emit receipt sent state when receipt is sent', () {
//     final receipt = Receipt(
//       recipient: '123',
//       messageId: '456',
//       status: ReceiptStatus.sent,
//       timestamp: DateTime.now(),
//     );
//
//     when(receiptService.send(receipt)).thenAnswer((_) async => true);
//     _receiptBloc.add(ReceiptEvent.onReceiptSent(receipt));
//     expectLater(_receiptBloc.stream, emits(ReceiptState.sent(receipt)));
//   });
//
//   test('should emit receipts received from service', () {
//     final receipt = Receipt(
//       recipient: '123',
//       messageId: '456',
//       status: ReceiptStatus.delivered,
//       timestamp: DateTime.now(),
//     );
//
//     when(receiptService.receipts(any))
//         .thenAnswer((_) => Stream.fromIterable([receipt]));
//
//     _receiptBloc.add(ReceiptEvent.onSubscribed(user));
//     expectLater(
//         _receiptBloc.stream, emitsInOrder([ReceiptReceivedSuccess(receipt)]));
//   });
// }
