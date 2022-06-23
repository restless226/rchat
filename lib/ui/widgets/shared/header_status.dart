import 'package:intl/intl.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final DateTime lastSeen;
  final bool typing;

  const HeaderStatus({
    Key key,
    @required this.username,
    @required this.imageUrl,
    @required this.online,
    this.lastSeen,
    @required this.typing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(
            imageUrl: imageUrl,
            online: online,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  username.trim(),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: typing == null
                    ? Text(
                        online
                            ? 'online'
                            : 'last seen ${DateFormat.yMd().add_jm().format(lastSeen)}',
                        style: Theme.of(context).textTheme.caption,
                      )
                    : Text(
                        'typing...',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
