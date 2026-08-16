class TodoItem {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final bool isComplete;
  TodoItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.isComplete,
  });

  TodoItem copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? createdAt,
    bool? isComplete,
  }) {
    return TodoItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isComplete': isComplete,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map, String docId) {
    final rawDate = map['createdAt'];
    DateTime parsedDate;

    if (rawDate is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is String) {
      parsedDate = DateTime.parse(rawDate);
    } else if (rawDate != null &&
        rawDate.runtimeType.toString() == 'Timestamp') {
      // Clever trick: We check the name of the type as a string!
      // This handles Firebase's object safely without importing the Firebase package.
      parsedDate = (rawDate as dynamic).toDate() as DateTime;
    } else {
      parsedDate = DateTime.now(); // Fallback if missing
    }
    return TodoItem(
      id: docId,
      userId: map['userId'] as String? ?? "",
      title: map['title'] as String? ?? "",
      createdAt: parsedDate,
      isComplete: map['isComplete'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'TodoItem(id: $id, userId: $userId, title: $title, createdAt: $createdAt, isComplete: $isComplete)';
  }
}
