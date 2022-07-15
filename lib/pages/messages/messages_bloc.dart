import 'package:domain/model/conversation.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'messages_bloc.freezed.dart';

@injectable
class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ConversationsRepository conversationsRepository;
  final MessagesRepository messagesRepository;
  final UsersRepository usersRepository;

  MessagesBloc(
    this.conversationsRepository,
    this.messagesRepository,
    this.usersRepository,
  ) : super(const MessagesState()) {
    on<InitEvent>((event, emit) async {
      var conversations = await conversationsRepository.fetchAll();
      var users = await usersRepository.findAll();

      conversations.result(
        onSuccess: (conversation) {
          emit(state.copyWith(conversations: conversation));
        },
        onError: (e) {},
      );

      users.result(
        onSuccess: (users) {
          emit(state.copyWith(users: users));
        },
        onError: (e) {},
      );

      emit(state.copyWith(isLoading: false));

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
    @Default([]) List<Conversation> conversations,
    @Default([]) List<User> users,
    @Default(true) bool isLoading,
  }) = Initial;
}
