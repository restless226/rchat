import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

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

// import 'dart:developer';
//
// import 'package:chat/src/models/user.dart';
// import 'package:chat/src/services/user/user_service_impl.dart';
// import 'package:flutter_test/flutter_test.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:rethinkdb_dart/rethinkdb_dart.dart';
//
// import 'helpers.dart';
//
// void main() {
//   Rethinkdb rethinkdb = Rethinkdb();
//   Connection? connection;
//   UserService? userService;
//
//   setUp(() async {
//     connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
//     await createDb(rethinkdb, connection!);
//     userService = UserService(connection!, rethinkdb);
//   });
//
//   tearDown(() async {
//     await cleanDb(rethinkdb, connection!);
//   });
//
//   test('create a new user document in database', () async {
//     final user = User(
//       username: 'test',
//       photoUrl: 'url',
//       active: true,
//       lastseen: DateTime.now(),
//     );
//
//     if (userService != null) {
//       final userWithId = await userService!.connect(user);
//       expect(userWithId.id, isNotEmpty);
//     } else {
//       log("userService is null");
//     }
//   });
// }




