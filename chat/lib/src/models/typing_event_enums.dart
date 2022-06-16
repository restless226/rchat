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