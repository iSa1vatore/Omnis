import 'package:flutter/material.dart';

import '../utils/emoji_utils.dart';

class Avatar extends StatelessWidget {
  final double width;
  final double height;
  final String source;

  const Avatar({
    Key? key,
    required this.width,
    required this.height,
    required this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (EmojiUtils.isEmojiAvatar(source)) {
      var avatarInfo = source.split("/");

      var colors = {
        "green": Colors.green,
        "orange": Colors.orange,
        "blue": Colors.blue,
        "red": Colors.red,
        "yellow": Colors.yellow,
        "purple": Colors.purple,
        "grey": Colors.grey,
        "teal": Colors.teal,
      };

      return Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          gradient: LinearGradient(
            colors: [
              colors[avatarInfo[3]]!.shade200,
              colors[avatarInfo[3]]!.shade400
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const [0, .6],
          ),
        ),
        child: Center(
          child: Text(
            avatarInfo[2],
            style: TextStyle(
              fontSize: width / 1.9,
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: Image.network(
          "https://media1.giphy.com/media/RtdRhc7TxBxB0YAsK6/giphy.gif",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
