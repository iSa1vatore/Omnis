import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/conversation.dart';
import 'package:omnis/router/router.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = AutoTabsRouter(
      navigatorObservers: () => [HeroController()],
      routes: const [
        ContactsRouter(),
        MessagesRoute(),
        SettingsRouter(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: Stack(
            children: <Widget>[
              context.platform.isAndroid
                  ? FadeTransition(
                      opacity: animation,
                      child: child,
                    )
                  : child,
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: context
                            .theme.bottomNavigationBarTheme.backgroundColor,
                        border: Border(
                          top: BorderSide(
                            color: context.theme.dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: BottomNavigationBar(
                        backgroundColor: Colors.transparent,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: const Icon(IconlyBold.user2),
                            label: context.loc.contacts,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(IconlyBold.chat),
                            label: context.loc.messages,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(IconlyBold.setting),
                            label: context.loc.settings,
                          ),
                        ],
                        currentIndex: tabsRouter.activeIndex,
                        onTap: tabsRouter.setActiveIndex,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );

    return context.responsiveValue<Widget>(
      mobile: body,
      tablet: Row(
        children: [
          Expanded(
            flex: 1,
            child: body,
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: context.theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: const ConversationPage(),
            ),
          ),
        ],
      ),
    );
  }
}
