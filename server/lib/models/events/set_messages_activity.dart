class SESetMessagesActivity {
  final int peerId;
  final int time;
  final String type;

  SESetMessagesActivity({
    required this.peerId,
    required this.type,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'peerId': peerId,
      'type': type,
      'time': time,
    };
  }
}
