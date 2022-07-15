import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../widgets/adaptive_app_bar.dart';
import '../../../../widgets/extended_scroll_view.dart';

class SettingsStoragePage extends StatelessWidget {
  const SettingsStoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context
        .safePadding(
          left: context.platform.isIos ? 16 : 0,
          right: context.platform.isIos ? 16 : 0,
        )
        .copyWith(
          top: context.appBarHeight,
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AdaptiveAppBar(
        title: context.loc.storage,
        previousPageTitle: context.loc.settings,
      ),
      body: ExtendedScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(padding: bodyPadding, child: const Text("Storage")),
          ),
        ],
      ),
    );
  }
}
