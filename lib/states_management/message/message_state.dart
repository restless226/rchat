part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  factory MessageState.initial() => MessageInitial();
  factory MessageState.sent(Message message) => MessageSentSuccess(message);
  factory MessageState.received(Message message) => MessageReceivedSuccess(message);

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {

}

class MessageSentSuccess extends MessageInitial {
  final Message message;

  MessageSentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceivedSuccess extends MessageInitial {
  final Message message;

  MessageReceivedSuccess(this.message);

  @override
  List<Object> get props => [message];
}