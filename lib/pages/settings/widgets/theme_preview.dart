import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/blur_effect.dart';

class ThemePreview extends StatelessWidget {
  final bool selected;

  const ThemePreview({
    Key? key,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: selected
              ? context.theme.colorScheme.primary
              : context.theme.dividerColor,
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 4),
              _buildExampleMessage(context, align: Alignment.centerLeft),
              _buildExampleMessage(context, align: Alignment.centerLeft),
              _buildExampleMessage(context),
              _buildExampleMessage(context, align: Alignment.centerLeft),
              _buildExampleMessage(context),
              _buildExampleMessage(context, align: Alignment.centerLeft),
              _buildExampleMessage(context),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildExampleNavPanel(context),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildExampleNavPanel(context, isAppBar: false),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleNavPanel(
    BuildContext context, {
    bool isAppBar = true,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isAppBar ? 12 : 0),
        topRight: Radius.circular(isAppBar ? 12 : 0),
        bottomLeft: Radius.circular(isAppBar ? 0 : 12),
        bottomRight: Radius.circular(isAppBar ? 0 : 12),
      ),
      child: BlurEffect(
        sigma: 3,
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        backgroundColorOpacity: .65,
        child: Container(height: 15),
      ),
    );
  }

  Widget _buildExampleMessage(
    BuildContext context, {
    Alignment align = Alignment.centerRight,
  }) {
    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 8,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
