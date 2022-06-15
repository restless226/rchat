// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

Future<void> createDb(Rethinkdb rethinkdb, Connection connection) async {
  await rethinkdb.dbCreate('test').run(connection).catchError((e) => {});
  await rethinkdb.tableCreate('users').run(connection).catchError((e) => {});
  await rethinkdb.tableCreate('messages').run(connection).catchError((e) => {});
  await rethinkdb.tableCreate('receipts').run(connection).catchError((e) => {});
  await rethinkdb.tableCreate('typing_events').run(connection).catchError((e) => {});
}

Future<void> cleanDb(Rethinkdb rethinkdb, Connection connection) async {
  await rethinkdb.table('users').delete().run(connection);
  await rethinkdb.table('messages').delete().run(connection);
  await rethinkdb.table('receipts').delete().run(connection);
  await rethinkdb.tableCreate('typing_events').run(connection).catchError((e) => {});
}
