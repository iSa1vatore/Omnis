class Contact {
  final int userId;
  final String name;

  Contact({
    required this.userId,
    required this.name,
  });

  Contact copyWith({
    int? userId,
    String? name,
  }) {
    return Contact(
      userId: userId ?? this.userId,
      name: name ?? this.name,
    );
  }
}
