import 'package:chat/src/models/user.dart';

abstract class IUserService {
  Future<User> connect(User user);  // creates a new user by connecting with rethinkDb

  Future<List<User>> online();  // returns a list of users which are currently online

  Future<void> disconnect(User user); // closes connection with rethinkDb when an user closes the application

  Future<User> fetch(String? id);
}