import 'package:flutter/foundation.dart';

enum Typing {
  start, stop,
}

extension EnumParsing on Typing {
  String value() {
    return this.toString().split('.').last;
  }

  static Typing fromString(String event) {
    return Typing.values
        .firstWhere((element) => element.value() == event);
  }
}

class TypingEvent {
  final String? from;
  final String? to;
  final Typing? event;
  String? _typingId;

  String? get id => _typingId;

  TypingEvent({
    @required this.from,
    @required this.to,
    @required this.event,
  });

  Map<String, dynamic> toJson() => {
    'from': this.from,
    'to': this.to,
    'event': event?.value(),
  };

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    TypingEvent _typingEvent = TypingEvent(
      from: json['from'],
      to: json['to'],
      event: EnumParsing.fromString(json['event']),
    );
    _typingEvent._typingId = json['id'];
    return _typingEvent;
  }
}