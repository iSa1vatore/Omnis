import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/bloc/conversation_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation_details/widgets/button_block.dart';
import 'package:omnis/widgets/adaptive_button.dart';
import 'package:omnis/widgets/avatar.dart';

import '../../widgets/adaptive_app_bar.dart';
import '../../widgets/extended_scroll_view.dart';
import '../../widgets/list.dart';

class ConversationDetailsPage extends StatelessWidget {
  const ConversationDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context
        .safePadding(
          left: 16,
          right: 16,
        )
        .copyWith(
          top: context.appBarHeight + 16,
        );

    var conversationBloc = context.read<ConversationBloc>();
    var user = conversationBloc.state.user!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AdaptiveAppBar(
        title: context.loc.info,
        previousPageTitle: context.loc.back,
        trailing: AdaptiveButton(
          padding: EdgeInsets.zero,
          title: "Edit",
          onPressed: () {},
        ),
      ),
      body: ExtendedScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: bodyPadding,
              child: Column(
                children: [
                  Avatar(
                    width: 90,
                    height: 90,
                    source: user.photo,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: context.textTheme.titleLarge,
                  ),
                  Text(
                    "Online",
                    style: context.theme.textTheme.caption,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonBlock(
                          onTap: () {},
                          icon: CupertinoIcons.person_add_solid,
                          title: context.loc.add,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ButtonBlock(
                          onTap: () {},
                          icon: Icons.notifications_off_rounded,
                          title: context.loc.mute,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ButtonBlock(
                          onTap: () {},
                          icon: Icons.block_rounded,
                          title: context.loc.block,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CellList(
                    children: [
                      ListItem(
                        title: context.loc.reconnectViaQrCode,
                        icon: IconlyBold.scan,
                      ),
                      ListItem(
                        title: context.loc.showQrCodeForReconnect,
                        icon: CupertinoIcons.qrcode,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CellList(
                    children: [
                      ListItem(
                        desc: '5',
                        title: context.loc.photos,
                        icon: IconlyBold.image2,
                      ),
                      ListItem(
                        desc: '10',
                        title: context.loc.videos,
                        icon: IconlyBold.video,
                      ),
                      ListItem(
                        desc: '40',
                        title: context.loc.files,
                        icon: IconlyBold.paper,
                      ),
                      ListItem(
                        desc: '50',
                        title: context.loc.audio_files,
                        icon: Icons.music_note_rounded,
                      ),
                      ListItem(
                        desc: '142',
                        title: context.loc.voice_messages,
                        icon: IconlyBold.voice,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
