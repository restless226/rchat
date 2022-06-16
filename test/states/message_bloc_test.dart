// import 'package:chat/chat.dart';
// import 'package:my_chat_app/states_management/message/typing_notification_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// class FakeMessageService extends Mock implements IMessageService {}
//
// void main() {
//   MessageBloc _messageBloc;
//   IMessageService messageService;
//   User user;
//
//   setUp(() {
//     messageService = FakeMessageService();
//     user = User(
//       username: 'test',
//       photoUrl: '',
//       active: true,
//       lastSeen: DateTime.now(),
//     );
//     _messageBloc = MessageBloc(messageService);
//   });
//
//   tearDown(() => _messageBloc.close());
//
//   test('should emit initial state only without subscriptions', () {
//     expect(_messageBloc.state, MessageInitial());
//   });
//
//   test('should emit message sent state when message is sent', () {
//     final message = Message(
//       from: '123',
//       to: '456',
//       contents: 'test message',
//       timestamp: DateTime.now(),
//     );
//
//     when(messageService.send([message])).thenAnswer((_) async => null);
//     _messageBloc.add(MessageEvent.onMessageSent([message]));
//     expectLater(_messageBloc.stream, emits(MessageState.sent(message)));
//   });
//
//   test('should emit messages received from service', () {
//     final message = Message(
//       from: '123',
//       to: '456',
//       contents: 'test message',
//       timestamp: DateTime.now(),
//     );
//
//     when(messageService.messages(activeUser: anyNamed('activeUser')))
//         .thenAnswer((_) => Stream.fromIterable([message]));
//
//     _messageBloc.add(MessageEvent.onSubscribed(user));
//     expectLater(_messageBloc.stream, emitsInOrder([MessageReceivedSuccess(message)]));
//   });
// }
