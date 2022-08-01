import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omnis/bloc/settings_bloc.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../bloc/auth_bloc.dart';
import '../../theme/base_theme.dart';
import '../../utils/emoji_utils.dart';
import '../../widgets/adaptive_button.dart';
import '../../widgets/avatar.dart';
import '../../widgets/simple_color_selector.dart';

class AuthPage extends HookWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<AuthBloc>();
    var settingsBloc = context.watch<SettingsBloc>();

    var allowContinue = useState(false);
    final textController = useTextEditingController();
    final avatar = useState<String>(EmojiUtils.getRandomEmojiAvatar());

    var loading = bloc.state.when(
      authorized: (user) => false,
      loading: () => true,
      unauthorized: () => false,
    );

    textController.addListener(() {
      allowContinue.value = textController.text.isNotEmpty;
    });

    void auth() {
      bloc.add(AuthEvent.auth(
        name: textController.text,
        avatar: avatar.value,
      ));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(maxWidth: 375),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    context.loc.appName,
                    style: context.textTheme.headline2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.loc.createProfile,
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 64),
                  Text(
                    context.loc.avatar.toUpperCase(),
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 85,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: AdaptiveButton(
                            onPressed: () {},
                            title: context.loc.select,
                          ),
                        ),
                        Avatar(
                          width: 85,
                          height: 85,
                          source: avatar.value,
                        ),
                        Positioned(
                          right: 0,
                          child: AdaptiveButton(
                            onPressed: () {
                              avatar.value = EmojiUtils.getRandomEmojiAvatar();
                            },
                            title: context.loc.random,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: TextField(
                      enabled: !loading,
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: context.loc.enterYourName,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    context.loc.accentColor.toUpperCase(),
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SimpleColorSelector(
                    colors: BaseTheme.accents,
                    selectedColor: settingsBloc.state.interfaceColorAccent,
                    onChange: (i) =>
                        settingsBloc.add(
                          SettingsEvent.setThemeAccent(i),
                        ),
                  ),
                  const SizedBox(height: 64),
                  SizedBox(
                    width: double.infinity,
                    child: AdaptiveButton.filled(
                      loading: loading,
                      onPressed: loading || !allowContinue.value ? null : auth,
                      title: context.loc.authContinue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
