// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';

class ActiveUsers extends StatefulWidget {
  ActiveUsers({Key key}) : super(key: key);

  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {

  _listItem() => ListTile(
    leading: const ProfileImage(
      imageUrl: '',
      online: true,
    ),
    title: Text(
      'random',
      style: Theme.of(context).textTheme.caption.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 30.0, right: 16.0),
      itemBuilder: (_, index) => _listItem(),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: 3,
    );
  }
}
