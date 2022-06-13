import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {
  
  final Connection _connection;
  final Rethinkdb _rethinkdb;

  UserService(this._connection, this._rethinkdb);
  
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

  @override
  Future<void> disconnect(User user) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<User>> online() {
    // TODO: implement online
    throw UnimplementedError();
  }

}