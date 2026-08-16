import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/firebase_options.dart';
import 'package:todo_app_new/providers/auth_provider.dart';
import 'package:todo_app_new/screens/auth_screen.dart';
import 'package:todo_app_new/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authData = ref.watch(authProvider);
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: authData.when(
        data: (data) {
          if (data != null) {
            return HomeScreen();
          } else {
            return AuthScreen();
          }
        },
        error: (error, stackTrace) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text(error.toString()),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(authProvider);
                    },
                    child: Text("Retry!"),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => Scaffold(body: const CircularProgressIndicator()),
      ),
    );
  }
}
