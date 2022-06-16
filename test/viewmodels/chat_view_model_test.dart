// import 'package:chat/chat.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:my_chat_app/data/datasources/datasource_contract.dart';
// import 'package:my_chat_app/models/chat.dart';
// import 'package:my_chat_app/models/local_message.dart';
// import 'package:my_chat_app/viewmodels/chat_view_models.dart';
//
// class MockDatasource extends Mock implements IDataSource {}
//
// void main() {
//   ChatViewModel _chatViewModel;
//   MockDatasource mockDatasource;
//
//   setUp(() {
//     mockDatasource = MockDatasource();
//     _chatViewModel = ChatViewModel(mockDatasource);
//   });
//
//   final message = Message.fromJson({
//     'from': '111',
//     'to': '222',
//     'contents': 'hey',
//     'timestamp': DateTime.parse("2021-04-01"),
//     'id': '4444'
//   });
//
//   test('initial messages return empty list', () async {
//     when(mockDatasource.findMessages(any)).thenAnswer((_) async => []);
//     expect(await _chatViewModel.getMessages('123'), isEmpty);
//   });
//
//   test('returns list of messages from local storage', () async {
//     final chat = Chat('123', ChatType.individual, membersId: []);
//     final localMessage =
//     LocalMessage(chat.id, message, ReceiptStatus.delivered);
//     when(mockDatasource.findMessages(chat.id))
//         .thenAnswer((_) async => [localMessage]);
//     final messages = await _chatViewModel.getMessages('123');
//     expect(messages, isNotEmpty);
//     expect(messages.first.chatId, '123');
//   });
//
//   test('creates a new chat when sending first message', () async {
//     when(mockDatasource.findChat(any)).thenAnswer((_) async => null);
//     await _chatViewModel.sentMessage(message);
//     verify(mockDatasource.addChat(any)).called(1);
//   });
//
//   test('add new sent message to the chat', () async {
//     final chat = Chat('123', ChatType.individual, membersId: []);
//     final localMessage =
//     LocalMessage(chat.id, message, ReceiptStatus.deliverred);
//     when(mockDatasource.findMessages(chat.id))
//         .thenAnswer((_) async => [localMessage]);
//
//     await _chatViewModel.getMessages(chat.id);
//     await _chatViewModel.sentMessage(message);
//
//     verifyNever(mockDatasource.addChat(any));
//     verify(mockDatasource.addMessage(any)).called(1);
//   });
//
//   test('add new received message to the chat', () async {
//     final chat = Chat('111', ChatType.individual, membersId: []);
//     final localMessage =
//     LocalMessage(chat.id, message, ReceiptStatus.deliverred);
//     when(mockDatasource.findMessages(chat.id))
//         .thenAnswer((_) async => [localMessage]);
//     when(mockDatasource.findChat(chat.id)).thenAnswer((_) async => chat);
//
//     await _chatViewModel.getMessages(chat.id);
//     await _chatViewModel.receivedMessage(message);
//
//     verifyNever(mockDatasource.addChat(any));
//     verify(mockDatasource.addMessage(any)).called(1);
//   });
//
//   test('create new chat when message received is not apart of this chat',
//           () async {
//         final chat = Chat('123', ChatType.individual, membersId: []);
//         final localMessage =
//         LocalMessage(chat.id, message, ReceiptStatus.deliverred);
//         when(mockDatasource.findMessages(chat.id))
//             .thenAnswer((_) async => [localMessage]);
//         when(mockDatasource.findChat(chat.id)).thenAnswer((_) async => null);
//
//         await _chatViewModel.getMessages(chat.id);
//         await _chatViewModel.receivedMessage(message);
//
//         verify(mockDatasource.addChat(any)).called(1);
//         verify(mockDatasource.addMessage(any)).called(1);
//         expect(_chatViewModel.otherMessages, 1);
//       });
// }