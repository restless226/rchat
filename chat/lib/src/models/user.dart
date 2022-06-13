import 'package:flutter/foundation.dart';

class User {
  String? username;
  String? photoUrl;
  String? _id;
  bool? active;
  DateTime? lastseen;

  String? get id => _id;

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
    user._id = json['id'];
    return user;
  }
}
