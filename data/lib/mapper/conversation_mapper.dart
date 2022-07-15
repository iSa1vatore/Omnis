import 'package:data/sources/local/db/entity/conversation_entity.dart';
import 'package:domain/model/conversation.dart';

extension ConversationEntityToConversation on ConversationEntity {
  Conversation toConversation() {
    return Conversation(
      id: id,
      inRead: inRead,
      outRead: outRead,
      lastMessageId: lastMessageId,
    );
  }
}

extension ConversationToConversationEntity on Conversation {
  ConversationEntity toConversationEntity() {
    return ConversationEntity(
      id: id,
      inRead: inRead,
      outRead: outRead,
      lastMessageId: lastMessageId,
    );
  }
}
