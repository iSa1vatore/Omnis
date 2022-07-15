import 'package:flutter/material.dart';

import '../utils/emoji_utils.dart';

class Avatar extends StatelessWidget {
  final double width;
  final double height;
  final String url;

  const Avatar({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (EmojiUtils.isEmojiAvatar(url)) {
      var avatarInfo = url.split("/");

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
            "https://sun1-27.userapi.com/s/v1/if2/05zgnfXmsX9v3DEKf6mJWgagyrsvXEiCl56DTOlTB0vu4eKMkg0We4YpHJyD1x6Meb1O4x82CeHWdKDBisGn4uYK.jpg?size=100x100&quality=96&crop=228,357,1087,1087&ava=1"),
      ),
    );
  }
}
