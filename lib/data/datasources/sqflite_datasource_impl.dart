import 'package:my_chat_app/data/datasources/datasource_contract.dart';
import 'package:my_chat_app/models/chat.dart';
import 'package:my_chat_app/models/local_message.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDataSource implements IDataSource {

  final Database _database;

  const SqfliteDataSource(this._database);

  @override
  Future<void> addChat(Chat chat) async {
    await _database.insert('chats', chat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _database.insert('messages', message.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// we want to delete a particular chat from "chats" table and also
  /// all messages associated with that chat in "messages" table in a single transaction
  /// for that batch processing from sqflite package is used which runs the queries together as a group
  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _database.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'chat_id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    /// all queries are run on same transaction object
    /// we don not want to use different txn object for each query as it can cause "deadlock"
    return _database.transaction((txn) async {

      final chatsWithLatestMessages = await txn.rawQuery(''' SELECT messages.* FROM
        (SELECT 
          chat_id, MAX(created_at) AS created_at
          FROM messages
          GROUP BY chat_id
        ) 
        AS latest_messages
        INNER JOIN messages
        ON messages.chat_id = latest_messages.chat_id
        AND messages.created_at = latest_messages.created_at
        ORDER BY messages.created_at DESC'''
      );

      if (chatsWithLatestMessages.isEmpty) return [];

      /// messages which are "delivered" but not read are unread messages
      final chatsWithUnreadMessages = await txn.rawQuery(''' 
        SELECT chat_id, count(*) as unread 
        FROM messages
        WHERE receipt = ?
        GROUP BY chat_id
        ''', ['delivered']
      );

      return chatsWithLatestMessages.map<Chat>((row) {
        final Object unread = chatsWithUnreadMessages.firstWhere(
            (ele) => row['chat_id'] == ele['chat_id'],
            orElse: () => {'unread': 0})['unread'];
        final chat = Chat.fromMap({'id': row['chat_id'], });
        print("unread = " + unread.toString());
        chat.unread = unread as int;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat> findChat(String chatId) async {
    return _database.transaction((txn) async {
        final listOfChatMaps = await txn.query(
            'chats',
            where: 'id = ?',
            whereArgs: [chatId]
        );

        if (listOfChatMaps.isEmpty) return null;

        final unread = Sqflite.firstIntValue(
          await txn.rawQuery(
              'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
              [chatId, 'delivered']
          )
        );

        final mostRecentMessage = await txn.query('messages',
            where: 'chat_id = ?',
            whereArgs: [chatId],
            orderBy: 'created_at DESC',
            limit: 1
        );

        final chat = Chat.fromMap(listOfChatMaps.first);
        chat.unread = unread;
        if (mostRecentMessage.isNotEmpty) {
          chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
        }

        return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    var listOfMaps = await _database.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _database.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message?.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

}