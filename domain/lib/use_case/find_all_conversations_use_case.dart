import 'package:dartz/dartz.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:injectable/injectable.dart';

import '../exceptions/conversations_failure.dart';
import '../model/message.dart';
import '../model/ui_conversation.dart';

@injectable
class FindAllConversationsUseCase {
  final ConversationsRepository conversationsRepository;
  final MessagesRepository messagesRepository;

  FindAllConversationsUseCase(
    this.conversationsRepository,
    this.messagesRepository,
  );

  Future<Either<ConversationsFailure, List<UIConversation>>> call() async {
    var conversations = await conversationsRepository.findAll();

    return await conversations.fold(
      (error) => Left(error),
      (conversations) async {
        List<UIConversation> conversationsList = [];

        for (var conversation in conversations) {
          Message? lastMessage = await messagesRepository
              .findMessageById(conversation.lastMessageId)
              .then(
                (message) => message.fold((e) => null, (m) => m),
              );

          var unreadCount = await messagesRepository
              .fetchUnreadCount(
                peerId: conversation.id,
                lastReadId: conversation.outRead,
              )
              .then(
                (count) => count.fold((e) => 0, (c) => c),
              );
   
          conversationsList.add(UIConversation(
            id: conversation.id,
            inRead: conversation.inRead,
            outRead: conversation.outRead,
            lastMessageId: conversation.lastMessageId,
            lastMessage: lastMessage,
            unreadCount: unreadCount,
          ));
        }

        return Right(conversationsList);
      },
    );
  }
}
