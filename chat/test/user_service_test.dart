import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

/*
void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  UserService userService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    userService = UserService(connection, rethinkdb);

    tearDown(() async {
      await cleanDb(rethinkdb, connection);
    });

    test('create a new user document in database', () async {
      final user = User(
        username: 'test',
        photoUrl: 'url',
        active: true,
        lastseen: DateTime.now(),
      );

      final userWithId = await userService.connect(user);
      expect(userWithId.id, isNotEmpty);
    });

  });
}
*/

void main() {
  Rethinkdb _rethinkdb = Rethinkdb();
  Connection? _connection;
  UserService? _userService;

  setUp(() async {
    _connection = await _rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(_rethinkdb, _connection!);
    _userService = UserService(_connection!, _rethinkdb);
  });

  tearDown(() async {
    await cleanDb(_rethinkdb, _connection!);
  });

  /// test for creating a new user
  test('create a new user document in database', () async {
    final _user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );

    final _userWithId = await _userService!.connect(_user);
    expect(_userWithId.id, isNotEmpty);
  });

  /// test for fetching users which are online
  test('get online users', () async {
    final _user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );

    _userService!.connect(_user);

    final _users = await _userService!.online();
    expect(_users.length, 1);
  });
}




