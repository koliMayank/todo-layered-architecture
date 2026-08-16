import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/models/todo_item.dart';
import 'package:todo_app_new/providers/auth_provider.dart';

class TodoNotifier extends StreamNotifier<List<TodoItem>> {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addTodo(String title) async {
    final uid = ref.read(authProvider).value?.uid;
    if (uid == null) {
      throw Exception("Authentication session expried");
    }
    try {
      final docRef = _firestore.collection("todos").doc();
      final todo = TodoItem(
        id: docRef.id,
        userId: uid,
        title: title,
        createdAt: DateTime.now(),
        isComplete: false,
      );
      await docRef.set(todo.toMap());
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateTodoTitle(String docId, String title) async {
    try {
      await _firestore.collection("todos").doc(docId).update({"title": title});
    } catch (err) {
      rethrow;
    }
  }

  Future<void> toggleTodoStatus(String docId, bool isComplete) async {
    try {
      await _firestore.collection("todos").doc(docId).update({
        'isComplete': isComplete,
      });
    } catch (err) {
      rethrow;
    }
  }

  Future<void> delete(String docId) async {
    try {
      await _firestore.collection("todos").doc(docId).delete();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Stream<List<TodoItem>> build() {
    final authData = ref.watch(authProvider).value;
    if (authData == null) return Stream.value([]);

    return _firestore
        .collection("todos")
        .where("userId", isEqualTo: authData.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TodoItem.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}

final todoProvider = StreamNotifierProvider<TodoNotifier, List<TodoItem>>(
  () => TodoNotifier(),
);
