import 'package:domain/model/message.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/model/ui_conversation.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:domain/use_case/find_all_conversations_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'messages_bloc.freezed.dart';

@injectable
class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ConversationsRepository conversationsRepository;
  final MessagesRepository messagesRepository;
  final UsersRepository usersRepository;
  final FindAllConversationsUseCase findAllConversationsUseCase;

  MessagesBloc(
    this.conversationsRepository,
    this.messagesRepository,
    this.usersRepository,
    this.findAllConversationsUseCase,
  ) : super(const MessagesState()) {
    on<InitEvent>((event, emit) async {
      var conversations = await findAllConversationsUseCase();
      var users = await usersRepository.findAll();

      if (conversations.isRight()) {
        emit(state.copyWith(
          conversations: conversations.getOrElse(List.empty),
          users: users,
          isLoading: false,
        ));
      }

      emit.forEach<Message>(
        messagesRepository.observeMessages(),
        onData: (message) {
          var newCList = [...state.conversations];

          var cIndex = newCList.indexWhere(
            (c) => c.id == message.peerId,
          );

          newCList[cIndex] = newCList[cIndex].copyWith(lastMessage: message);

          return state.copyWith(conversations: newCList);
        },
      );

      await emit.forEach<List<MessageActivity>>(
        messagesRepository.observeMessageActivities(),
        onData: (activities) => state.copyWith(messageActivities: activities),
      );
    });
  }
}

@freezed
class MessagesEvent with _$MessagesEvent {
  const factory MessagesEvent.init() = InitEvent;
}

@freezed
class MessagesState with _$MessagesState {
  const MessagesState._();

  const factory MessagesState({
    @Default([]) List<MessageActivity> messageActivities,
    @Default([]) List<UIConversation> conversations,
    @Default([]) List<User> users,
    @Default(true) bool isLoading,
  }) = Initial;
}
