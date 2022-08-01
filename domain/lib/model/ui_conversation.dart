import 'package:domain/model/conversation.dart';

import 'message.dart';

class UIConversation extends Conversation {
  final Message? lastMessage;
  final int unreadCount;

  UIConversation({
    required super.id,
    required super.inRead,
    required super.outRead,
    required super.lastMessageId,
    required this.unreadCount,
    this.lastMessage,
  });

  UIConversation copyWith({
    int? id,
    int? inRead,
    int? outRead,
    int? unreadCount,
    int? lastMessageId,
    Message? lastMessage,
  }) {
    return UIConversation(
      id: id ?? this.id,
      inRead: inRead ?? this.inRead,
      outRead: outRead ?? this.outRead,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageId: lastMessageId ?? this.lastMessageId,
    );
  }
}
