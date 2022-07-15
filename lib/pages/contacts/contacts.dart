import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/adaptive_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../router/router.dart';
import '../../widgets/adaptive_sliver_app_bar.dart';
import '../../widgets/avatar.dart';
import '../../widgets/cell.dart';
import '../../widgets/page_link.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context.safePadding().copyWith(top: 0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AdaptiveSliverAppBar(title: context.loc.contacts),
          SliverToBoxAdapter(
            child: Padding(
              padding: bodyPadding.copyWith(bottom: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 16,
                      left: 16,
                      bottom: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: QrImage(
                            gapless: false,
                            data: "192.168.139.1:15110",
                            version: QrVersions.auto,
                            padding: EdgeInsets.zero,
                            foregroundColor: context.textTheme.bodyText1!.color,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.circle,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.scanQrCodeDesc,
                                style: context.textTheme.subtitle2,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                child: AdaptiveButton.filled(
                                  title: context.loc.scanQrCode,
                                  onPressed: () {},
                                  icon: IconlyBold.scan,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  PageLink(
                    route: const PeopleNearbyRoute(),
                    icon: IconlyBold.discovery,
                    title: context.loc.peopleNearby,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: bodyPadding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Cell(
                    avatar: const Avatar(
                      height: 50,
                      width: 50,
                      url: "emoji://👂/teal",
                    ),
                    title: "Сухожилие блять)",
                    caption: "Ебет собак",
                    before: Icon(
                      IconlyLight.chat,
                      color: context.theme.colorScheme.primary,
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
