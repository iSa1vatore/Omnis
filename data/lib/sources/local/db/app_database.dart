import 'dart:async';

import 'package:data/sources/local/db/dao/conversation_dao.dart';
import 'package:data/sources/local/db/entity/conversation_entity.dart';
import 'package:data/sources/local/db/entity/message_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

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
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;

  ConnectionDao get connectionDao;

  ConversationDao get conversationDao;

  MessagesDao get messagesDao;
}
