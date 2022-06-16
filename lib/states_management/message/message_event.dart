part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  factory MessageEvent.onSubscribed(User user) => Subscribed(user);

  factory MessageEvent.onMessageSent(Message message) => MessageSent(message);

  @override
  List<Object> get props => [];
}

class Subscribed extends MessageEvent {
  final User user;

  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class MessageSent extends MessageEvent {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

/// this class is useful for server purposes only not for client
class _MessageReceived extends MessageEvent {
  final Message message;

  const _MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}
