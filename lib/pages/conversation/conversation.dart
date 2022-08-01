import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/conversation_ui_controller.dart';
import 'package:omnis/pages/conversation/widgets/conversation_app_bar.dart';
import 'package:omnis/pages/conversation/widgets/messages_list.dart';
import 'package:omnis/pages/conversation/widgets/voice_record_lock.dart';
import 'package:omnis/pages/conversation/widgets/write_bar/write_bar.dart';
import 'package:omnis/pages/messages/widgets/voice_message_player.dart';

import '../../bloc/conversation_bloc.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  late final ConversationUIController uiController;

  @override
  void initState() {
    uiController = ConversationUIController()
      ..bloc = context.read<ConversationBloc>();

    super.initState();
  }

  static ConversationUIController uiControllerOf(
    BuildContext context,
  ) =>
      context
          .findRootAncestorStateOfType<ConversationPageState>()!
          .uiController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ConversationAppBar(),
      body: Stack(
        children: [
          BlocBuilder<ConversationBloc, ConversationState>(
            buildWhen: (prevState, state) =>
                prevState.isLoading != state.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return const SizedBox();
            },
          ),
          CustomScrollView(
            reverse: true,
            controller: uiController.messagesScrollController,
            slivers: [
              Observer(builder: (_) {
                return SliverPadding(
                  padding: EdgeInsets.only(
                    top: context.appBarHeight + 35,
                    bottom: uiController.writeBarHeight + 8,
                  ),
                  sliver: const MessagesList(),
                );
              })
            ],
          ),
          const VoiceMessagePlayer(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: WriteBar(),
          ),
          const VoiceRecordLock(),
        ],
      ),
    );
  }
}
