import 'dart:math';

import 'package:flutter/cupertino.dart';

class EmojiUtils {
  static final regexEmoji = RegExp(
    r'[\u{1f300}-\u{1f5ff}\u{1f900}-\u{1f9ff}\u{1f600}-\u{1f64f}'
    r'\u{1f680}-\u{1f6ff}\u{2600}-\u{26ff}\u{2700}'
    r'-\u{27bf}\u{1f1e6}-\u{1f1ff}\u{1f191}-\u{1f251}'
    r'\u{1f004}\u{1f0cf}\u{1f170}-\u{1f171}\u{1f17e}'
    r'-\u{1f17f}\u{1f18e}\u{3030}\u{2b50}\u{2b55}'
    r'\u{2934}-\u{2935}\u{2b05}-\u{2b07}\u{2b1b}'
    r'-\u{2b1c}\u{3297}\u{3299}\u{303d}\u{00a9}'
    r'\u{00ae}\u{2122}\u{23f3}\u{24c2}\u{23e9}'
    r'-\u{23ef}\u{25b6}\u{23f8}-\u{23fa}\u{200d}]+',
    unicode: true,
  );

  static bool hasOnlyEmojis(String text) {
    if (text.isEmpty) return false;

    for (final c in Characters(text)) {
      if (!regexEmoji.hasMatch(c)) return false;
    }
    return true;
  }

  static String getRandomEmojiAvatar() {
    var couples = [
      ["🥑", "green"],
      ["👻", "blue"],
      ["👽", "teal"],
      ["👾", "grey"],
      ["🥦", "green"],
      ["🔥", "blue"],
      ["🤮", "yellow"],
      ["🤡", "blue"],
      ["💩", "yellow"],
      ["💀", "purple"],
    ];

    var couple = couples[Random().nextInt(couples.length - 1)];

    return "emoji://${couple.first}/${couple.last}";
  }

  static bool isEmojiAvatar(String url) {
    return url.split(":").first == "emoji";
  }
}
