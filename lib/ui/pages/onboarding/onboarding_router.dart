import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IOnboardingRouter {
  void onSessionSuccess(BuildContext context, User me);
}

class OnboardingRouter implements IOnboardingRouter {
  final Widget Function(User me) onSessionConnected;

  OnboardingRouter({@required this.onSessionConnected});

  @override
  void onSessionSuccess(BuildContext context, User me) {
    /// Push the given route onto the navigator that most tightly encloses the given context,
    /// and then remove all the previous routes until the predicate returns true
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => onSessionConnected(me),
        ),
        (Route<dynamic> route) => false);
  }
}
