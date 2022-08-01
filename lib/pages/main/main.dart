import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/conversation/conversation.dart';
import 'package:omnis/pages/messages/widgets/voice_message_player.dart';
import 'package:omnis/router/router.dart';
import 'package:omnis/widgets/blur_effect.dart';

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
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              context.platform.isAndroid
                  ? FadeTransition(
                      opacity: animation,
                      child: child,
                    )
                  : child,
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VoiceMessagePlayer(inAppBar: false),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: BlurEffect(
                  backgroundColor:
                      context.theme.bottomNavigationBarTheme.backgroundColor,
                  backgroundColorOpacity: 0.65,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
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
                          icon: Stack(children: const <Widget>[
                            Icon(IconlyBold.chat),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.brightness_1,
                                size: 8.0,
                                color: Colors.redAccent,
                              ),
                            )
                          ]),
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
