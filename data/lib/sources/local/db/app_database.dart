import 'dart:async';

import 'package:data/sources/local/db/dao/cached_file_dao.dart';
import 'package:data/sources/local/db/dao/contact_dao.dart';
import 'package:data/sources/local/db/dao/conversation_dao.dart';
import 'package:data/sources/local/db/entity/cached_file_entity.dart';
import 'package:data/sources/local/db/entity/contact_entity.dart';
import 'package:data/sources/local/db/entity/conversation_entity.dart';
import 'package:data/sources/local/db/entity/message_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'converters/message_attachments_converter.dart';
import 'dao/connection_dao.dart';
import 'dao/messages_dao.dart';
import 'dao/user_dao.dart';
import 'entity/connection_entity.dart';
import 'entity/user_entity.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [
    UserEntity,
    ConnectionEntity,
    ConversationEntity,
    MessageEntity,
    ContactEntity,
    CachedFileEntity,
  ],
)
@TypeConverters([MessageAttachmentsConverter])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;

  ConnectionDao get connectionDao;

  ConversationDao get conversationDao;

  MessagesDao get messagesDao;

  ContactsDao get contactsDao;

  CachedFileDao get cachedFileDao;

  Future<int> selectCount({
    required String from,
    required String where,
  }) async {
    final result = await database.rawQuery(
      "SELECT COUNT(`id`) AS cnt FROM $from WHERE $where",
    );

    return result.isEmpty ? 0 : result[0]['cnt'] as int? ?? 0;
  }
}
