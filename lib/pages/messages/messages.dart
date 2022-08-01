import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../widgets/adaptive_sliver_app_bar.dart';
import '../../widgets/extended_scroll_view.dart';
import 'conversations_list.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedScrollView(
        slivers: [
          AdaptiveSliverAppBar(title: context.loc.messages),
          const ConversationsList(),
        ],
      ),
    );
  }
}
