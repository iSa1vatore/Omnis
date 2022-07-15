class Conversation {
  final int id;
  final int inRead;
  final int outRead;
  final int lastMessageId;

  Conversation({
    required this.id,
    required this.inRead,
    required this.outRead,
    required this.lastMessageId,
  });
}
