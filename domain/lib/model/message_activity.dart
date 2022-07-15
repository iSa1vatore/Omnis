import 'package:domain/enum/message_activity.dart';

class MessageActivity {
  final int peerId;
  final int time;
  final MessageActivityType type;

  MessageActivity({
    required this.peerId,
    required this.type,
    required this.time,
  });
}
