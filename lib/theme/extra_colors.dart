import 'package:flutter/material.dart';

class ExtraColors extends ThemeExtension<ExtraColors> {
  const ExtraColors({
    required this.secondaryIconColor,
    required this.messageBackgroundColor,
    required this.outMessageBackgroundColor,
    required this.outMessageTextColor,
    required this.messageBoxBorderColor,
    required this.messageTextColor,
    required this.dangerColor,
  });

  final Color? secondaryIconColor;
  final Color? messageBackgroundColor;
  final Color? outMessageBackgroundColor;
  final Color? messageBoxBorderColor;
  final Color? outMessageTextColor;
  final Color? messageTextColor;
  final Color? dangerColor;

  @override
  ThemeExtension<ExtraColors> copyWith({
    Color? secondaryIconColor,
    Color? messageBackgroundColor,
    Color? outMessageBackgroundColor,
    Color? messageBoxBorderColor,
    Color? outMessageTextColor,
    Color? messageTextColor,
    Color? dangerColor,
  }) {
    return ExtraColors(
      secondaryIconColor: secondaryIconColor ?? this.secondaryIconColor,
      messageBackgroundColor:
          messageBackgroundColor ?? this.messageBackgroundColor,
      outMessageBackgroundColor:
          outMessageBackgroundColor ?? this.outMessageBackgroundColor,
      messageBoxBorderColor:
          messageBoxBorderColor ?? this.outMessageBackgroundColor,
      outMessageTextColor: outMessageTextColor ?? this.outMessageTextColor,
      messageTextColor: messageTextColor ?? this.messageTextColor,
      dangerColor: dangerColor ?? this.dangerColor,
    );
  }

  @override
  ThemeExtension<ExtraColors> lerp(
    ThemeExtension<ExtraColors>? other,
    double t,
  ) {
    if (other is! ExtraColors) {
      return this;
    }

    return ExtraColors(
      secondaryIconColor:
          Color.lerp(secondaryIconColor, other.secondaryIconColor, t),
      messageBackgroundColor:
          Color.lerp(messageBackgroundColor, other.messageBackgroundColor, t),
      outMessageBackgroundColor: Color.lerp(
          outMessageBackgroundColor, other.outMessageBackgroundColor, t),
      messageBoxBorderColor:
          Color.lerp(messageBoxBorderColor, other.messageBoxBorderColor, t),
      outMessageTextColor:
          Color.lerp(outMessageTextColor, other.outMessageTextColor, t),
      messageTextColor: Color.lerp(messageTextColor, other.messageTextColor, t),
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t),
    );
  }
}
