class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    final rawDate = map['createdAt'];
    DateTime parsedDate;

    if (rawDate is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is String) {
      parsedDate = DateTime.parse(rawDate);
    } else if (rawDate != null &&
        rawDate.runtimeType.toString() == 'Timestamp') {
      parsedDate = (rawDate as dynamic).toDate() as DateTime;
    } else {
      parsedDate = DateTime.now();
    }
    return UserModel(
      id: docId,
      name: map['name'] as String? ?? "",
      email: map['email'] as String? ?? "",
      createdAt: parsedDate,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }
}
