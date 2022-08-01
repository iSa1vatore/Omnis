import 'package:domain/enum/message_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:omnis/bloc/conversation_bloc.dart';

part 'conversation_ui_controller.g.dart';

class ConversationUIController = ConversationUIControllerBase
    with _$ConversationUIController;

abstract class ConversationUIControllerBase with Store {
  @observable
  double voiceRecordBoxYOffset = 0;
  @observable
  double writeBarXOffset = 0;
  @observable
  bool showSendButton = false;
  @observable
  double writeBarHeight = 90;

  late ConversationBloc bloc;

  var messagesScrollController = ScrollController();
  var messageTextController = TextEditingController();

  ConversationUIControllerBase() {
    messagesScrollController.addListener(messagesScrollListener);
    messageTextController.addListener(messageTextListener);
  }

  void messagesScrollListener() {
    if (messagesScrollController.position.extentAfter < 300) {
      bloc.add(const ConversationEvent.loadMoreMessages());
    }
  }

  void messageTextListener() {
    if (messageTextController.text.isEmpty) {
      if (showSendButton) showSendButton = false;
    } else {
      bloc.add(const ConversationEvent.setActivity(
        MessageActivityType.typing,
      ));

      if (!showSendButton) showSendButton = true;
    }
  }

  @action
  void setWriteBarHeight(double height) {
    writeBarHeight = height;
  }

  @action
  void cancelVoiceRecord() {
    bloc.add(const ConversationEvent.stopVoiceRecording(send: false));

    voiceRecordBoxYOffset = 0;
    writeBarXOffset = 0;
  }

  @action
  void sendVoiceMessage() {
    voiceRecordBoxYOffset = 0;
    writeBarXOffset = 0;

    bloc.add(const ConversationEvent.stopVoiceRecording());
  }

  @action
  void sendMessage() {
    bloc.add(ConversationEvent.sendMessage(
      messageTextController.text,
    ));

    messageTextController.text = "";
  }

  @action
  void onVoiceButtonGesture(LongPressMoveUpdateDetails gesture) {
    double offsetY = gesture.localOffsetFromOrigin.dy;
    double offsetX = gesture.localOffsetFromOrigin.dx;

    if (offsetX < -35) {
      writeBarXOffset = offsetX + 35;

      return;
    }

    if (offsetY < -60) {
      var offset = -(offsetY + 60);

      if (!bloc.state.isPermanentVoiceRecording) {
        voiceRecordBoxYOffset = offset;
      }

      if (offset > 30) {
        bloc.add(const ConversationEvent.setPermanentVoiceRecording());
      }
    }
  }
}
