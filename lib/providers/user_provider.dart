import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/models/user.dart';

class UserNotifier extends Notifier<UserModel?> {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set(user.toMap());
      state = user;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> getUser(String userId) async {
    try {
      final doc = await _firestore.collection("users").doc(userId).get();
      if (doc.exists && doc.data() != null) {
        state = UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (err) {}
  }

  void clearProfile() {
    state = null;
  }

  @override
  UserModel? build() {
    return null;
  }
}

final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  () => UserNotifier(),
);
