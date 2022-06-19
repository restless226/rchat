import 'package:flutter/material.dart';
import 'package:my_chat_app/colors.dart';
import 'package:my_chat_app/theme.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';

class Chats extends StatefulWidget {
  const Chats({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  _chatItem() => ListTile(
    contentPadding: const EdgeInsets.only(left: 16.0),
        leading: const ProfileImage(
          imageUrl: '',
          online: true,
        ),
        title: Text(
          'Rohit',
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: Text(
          'Thank you so much',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.overline.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70,
              ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '12pm',
              style: Theme.of(context).textTheme.overline.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 15,
                  width: 15,
                  color: kPrimary,
                  alignment: Alignment.center,
                  child: Text(
                    '2',
                    style: Theme.of(context).textTheme.overline.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 30.0, right: 16.0),
      itemBuilder: (_, index) => _chatItem(),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: 3,
    );
  }
}
