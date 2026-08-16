import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StreamNotifier<User?> {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> createUser(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      rethrow;
    }
  }

  Future<UserCredential> logInUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Stream<User?> build() {
    return _auth.authStateChanges();
  }

  //fake error state
  //   @override
  // Stream<User?> build() {
  //   throw Exception("Simulated Firebase Connection Failure!");
  // }
}

final authProvider = StreamNotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
