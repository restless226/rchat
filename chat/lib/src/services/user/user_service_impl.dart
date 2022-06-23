import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {

  final Connection _connection;
  final Rethinkdb _rethinkdb;

  UserService(this._connection, this._rethinkdb);

  /// creates a new user by connecting with rethinkDb
  @override
  Future<User> connect(User user) async {
    var data = user.toJson();
    if (user.id != null) data['id'] = user.id;

    /// query to create a new user
    /// if user already exists then user is updated else a new user object is created
    final result = await _rethinkdb
        .table('users')
        .insert(data, {'conflict': 'update', 'return_changes': true,})
        .run(_connection);

    return User.fromJson(result['changes'].first['new_val']);
  }

  /// returns a list of users which are currently online
  @override
  Future<void> disconnect(User user) async {
    await _rethinkdb
        .table('users')
        .update({'id': user.id, 'active': false, 'last_seen': DateTime.now()})
        .run(_connection);
    _connection.close();
  }

  /// closes connection with rethinkDb when an user closes the application
  @override
  Future<List<User>> online() async {
    Cursor _activeUsers = await _rethinkdb
        .table('users')
        .filter({'active': true})
        .run(_connection);
    final _activeUsersList = await _activeUsers.toList();
    return _activeUsersList.map((item) => User.fromJson(item)).toList();
  }

  @override
  Future<User> fetch(String? id) async {
    final user = await _rethinkdb.table('users').get(id).run(_connection);
    return User.fromJson(user);
  }

}