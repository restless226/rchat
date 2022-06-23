import 'package:flutter/material.dart';
import 'package:my_chat_app/colors.dart';

import 'online_indicator.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final bool online;

  const ProfileImage({
    Key key,
    @required this.imageUrl,
    this.online = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: imageUrl != null ? Colors.transparent : kBubbleLight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126.0),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 126,
                    height: 126,
                    fit: BoxFit.fill,
                  )
                : const Icon(
                    Icons.group_rounded,
                    size: 35,
                    color: kPrimary,
                  ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: online ? const OnlineIndicator() : Container(),
          ),
        ],
      ),
    );
  }
}
