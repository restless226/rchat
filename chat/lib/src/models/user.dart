import 'package:flutter/foundation.dart';

class User {
  final String? username;
  final String? photoUrl;
  String? _userId;
  final bool? active;
  final DateTime? lastseen;

  String? get id => _userId;

  User({
    @required this.username,
    @required this.photoUrl,
    @required this.active,
    @required this.lastseen,
  });

  toJson() => {
        'username': username,
        'photoUrl': photoUrl,
        'active': active,
        'lastseen': lastseen,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json['username'],
      photoUrl: json['photoUrl'],
      active: json['active'],
      lastseen: json['lastseen'],
    );
    user._userId = json['id'];
    return user;
  }
}
