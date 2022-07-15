import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../widgets/adaptive_app_bar.dart';
import '../../../../widgets/extended_scroll_view.dart';

class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context.safePadding().copyWith(
          top: context.appBarHeight,
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AdaptiveAppBar(
        title: context.loc.about,
        previousPageTitle: context.loc.settings,
      ),
      body: ExtendedScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: bodyPadding,
              child: const Center(
                child: Text("Omnis: 1.0.1"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
