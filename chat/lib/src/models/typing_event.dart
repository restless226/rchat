import 'package:chat/src/models/typing_event_enums.dart';
import 'package:flutter/foundation.dart';

class TypingEvent {
  final String? from;
  final String? to;
  final Typing? event;
  String? _typingId;
  String? chatId;

  String? get id => _typingId;

  TypingEvent({
    @required this.chatId,
    @required this.from,
    @required this.to,
    @required this.event,
  });

  Map<String, dynamic> toJson() => {
    'chat_id': this.chatId,
    'from': this.from,
    'to': this.to,
    'event': event?.value(),
  };

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    TypingEvent _typingEvent = TypingEvent(
      chatId: json['chat_id'],
      from: json['from'],
      to: json['to'],
      event: EnumParsing.fromString(json['event']),
    );
    _typingEvent._typingId = json['id'];
    return _typingEvent;
  }
}