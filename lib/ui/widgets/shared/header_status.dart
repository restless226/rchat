import 'package:my_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final String description;
  final String typing;

  const HeaderStatus(this.username, this.imageUrl, this.online,
      {Key key, this.description, this.typing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 14.0)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: typing == null
                    ? Text(
                        online ? 'online' : description,
                        style: Theme.of(context).textTheme.caption,
                      )
                    : Text(
                        typing,
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
