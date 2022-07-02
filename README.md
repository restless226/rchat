# RChat

<p align="center">
  <img src="/images/preview.png" height="450" width="450" hspace="10" vspace="10">
  <img src="/images/architecture.png "height="450" width="450" hspace="10" vspace="10">
</p>
<p align="center">
  RChat is a <strong>Group Chat Application</strong> made using Flutter, Docker and RethinkDB.<br/>
  Services Provided are: User Service Message Service, Receipt Service, Typing Notification Service.
</p>

## Installing

These instructions will get you a copy of the project set-up and running on your local machine for development purposes.

#### Clone

To clone this repository copy and paste the following command in your terminal.

```
git clone https://github.com/restless226/rchat.git
```

#### Prerequisites

These are the prerequisites that you will need to run this app for your own.

- This app uses Docker and NodeJS so you will have to create one for yourself.
- Android Studio - To build the app for Android devices.
- XCode - To build the app for IOS devices.

## About
- A cross-platform group chat application using AES end to end message encryption.
- Used Bloc Providers and Cubits for state management and performed widget tests for services.

## Tech Stack Used
- Flutter, Docker, RehinkDB, NodeJS, Sqflite, Android, Dart.

## Built with

- [Flutter](https://flutter.dev/) - The framework
- [Docker](https://www.docker.com/) - The framework
- [RethinkDB](https://rethinkdb.com/) - The open-source database
- [Dart](https://dart.dev/) - The programming language

## Important Packages Used

- [BlocProvider](https://pub.dev/packages/flutter_bloc) - For State Management and dependancy injections.
- [Cubit](https://pub.dev/documentation/flutter_cubit/latest/) - For State Management.
- [testUI](https://pub.dev/packages/flutter_test_ui) - For Widget Testing.
- [RethinkDB](https://pub.dev/packages/rethink_db_ns) - For RethinkDB database usage.
- [sqflite](https://pub.dev/packages/sqflite) - For creating Chats and Messages tables.
- [Encrypter](https://pub.dev/packages/encrypt) - For two-way AES implementation.
- [npm](https://www.npmjs.com/) - For storing Profile Images on node server.
- [Shared Preferences](https://pub.dev/packages/shared_preferences) - For caching some data.
- [Google Fonts](https://pub.dev/packages/google_fonts) - For the fonts.

## Screenshots

### Onboarding Screen

|**Without Profile Pic**|**With Profile Pic Light**|**With Profile Pic Dark**|
|---|---|--|
|<img src="/images/onboarding_screen_without_profile_pic_dark.jpeg" height="600"/>|<img src="/images/onboarding_screen_with_profile_pic_light.jpeg" height="600"/>|<img src="/images/onboarding_screen_with_profile_pic_dark.jpeg" height="600"/>|

### Group Chat

|**Group Creation Selecting Members**|**Group Creation Screen**|**Group Created**|
|---|---|---|
|<img src="/images/group_creation_selecting_members.png" height="600"/>|<img src="/images/group_creation.png" height="600"/>|<img src="/images/group_teams_created_successfully.png" height="600"/>|

|**Group Chat Unread Message**|
|---|
|<img src="/images/group_chat_unread_message.png" height="600"/>|

|**Group Chat Typing Notification**|
|---|
|<img src="/images/group_chat_typing_notification.png" height="600"/>|

### Personal Chat

|**Active Chats**|**Active Chats Dark Theme**|**Unread Message is Prioritized over Groups**|
|---|---|--|
|<img src="/images/added_active_chats.png" height="600"/>|<img src="/images/added_active_chats.png" height="600"/>|<img src="/images/unread_message_is_prioritized_over_group.png" height="600"/>|

|**Online Status**|
|---|
|<img src="/images/online_status.png" height="600"/>|

|**Chats Both Sides**|
|---|
|<img src="/images/chat_both_ways.png" height="600"/>|

### Message Functionality

|**Message Threads Screen Seup**|**Message Sent Working**|
|---|---|
|<img src="/images/message_threads_screen_setup.png" height="600"/>|<img src="/images/message_sent_working_successfully.png" height="600"/>|

|**Message Sent**|
|---|
|<img src="/images/two_devices_message_sent.png" height="600"/>|

|**Message Read**|
|---|
|<img src="/images/two_devices_message_read.png" height="600"/>|

|**Message Typing Notification**|
|---|
|<img src="/images/two_devices_typing_notification.png" height="600"/>|

|**Multiple Messages Scroll Till End**|
|---|
|<img src="/images/multiple_messages_scroll_till_end.png" height="600"/>|

### Unread Messages

|**Unread Message**|
|---|
|<img src="/images/unread_message.png" height="600"/>|

|**Unread Message**|
|---|
|<img src="/images/unread_chat_goes_to_top.png" height="600"/>|

|**Unread Chat goes to top**|
|---|
|<img src="/images/unread_chat_goes_to_top.png" height="600"/>|


