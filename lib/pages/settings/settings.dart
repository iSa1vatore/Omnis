import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../router/router.dart';
import '../../widgets/adaptive_sliver_app_bar.dart';
import '../../widgets/page_link.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var bodyPadding = context.safePadding().copyWith(top: 0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AdaptiveSliverAppBar(title: context.loc.settings),
          SliverToBoxAdapter(
            child: Padding(
              padding: bodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageLink(
                    route: const SettingsProfileRoute(),
                    icon: IconlyBold.profile,
                    title: context.loc.profile,
                  ),
                  PageLink(
                    route: const SettingsInterfaceRoute(),
                    icon: IconlyBold.category,
                    title: context.loc.interface,
                  ),
                  PageLink(
                    route: const SettingsConnectionRoute(),
                    icon: IconlyBold.upload,
                    title: context.loc.connection,
                  ),
                  PageLink(
                    route: const SettingsStorageRoute(),
                    icon: IconlyBold.folder,
                    title: context.loc.storage,
                  ),
                  PageLink(
                    route: const SettingsAboutRoute(),
                    icon: IconlyBold.infoSquare,
                    title: context.loc.about,
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
