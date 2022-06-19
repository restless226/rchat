import 'package:flutter/material.dart';
import 'package:my_chat_app/ui/widgets/home/active/active_users.dart';
import 'package:my_chat_app/ui/widgets/home/chats/chats.dart';
import 'package:my_chat_app/ui/widgets/home/profile_image.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  const ProfileImage(
                    imageUrl: '',
                    online: true,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'username',
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text('online',
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ],
                  )
                ],
              ),
            ),
            bottom: TabBar(
              indicatorPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text('Messages'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text('Active'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Chats(),
                ActiveUsers(),
              ],
            ),
          ),
        ));
  }
}
