import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/models/user.dart';
import 'package:todo_app_new/providers/auth_provider.dart';
import 'package:todo_app_new/providers/user_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _password;
  bool _isLogIn = true;
  bool _isLoding = false;
  final _formKey = GlobalKey<FormState>();

  void _toggleForm() {
    setState(() {
      _isLogIn = !_isLogIn;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoding = true;
    });

    final email = _email.text.trim();
    final password = _password.text.trim();

    try {
      if (_isLogIn) {
        final userData = await ref
            .read(authProvider.notifier)
            .logInUser(email, password);
        if (userData.user != null) {
          await _getUserFromDatabase(userData.user!.uid);
        }
      } else {
        final userData = await ref
            .read(authProvider.notifier)
            .createUser(email, password);
        if (userData.user != null) {
          await _addNewUserToDatabase(userData.user!.uid);
        }
      }
      if (mounted) {
        setState(() {
          _isLoding = false;
        });
      }
    } catch (err) {
      _showError(err.toString());
    }
  }

  Future<void> _addNewUserToDatabase(String userId) async {
    final newUser = UserModel(
      id: userId,
      name: _name.text.trim(),
      email: _email.text.trim(),
      createdAt: DateTime.now(),
    );
    await ref.read(userProvider.notifier).addNewUser(newUser);
  }

  Future<void> _getUserFromDatabase(String userId) async {
    await ref.read(userProvider.notifier).getUser(userId);
  }

  void _showError(String title) {
    if (mounted) {
      setState(() {
        _isLoding = false;
      });
      String clearMessage = title;
      if (title.contains(']')) {
        clearMessage = title.split(']').last.trim();
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Server Error: $clearMessage")));
    }
  }

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLogIn) ...[
                          TextFormField(
                            key: ValueKey("name"),
                            controller: _name,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(labelText: "Name"),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 2) {
                                return "Name should be atleast 2 characters long";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                        TextFormField(
                          key: ValueKey("email"),
                          controller: _email,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: "Email"),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains("@")) {
                              return "Please provide a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: ValueKey("password"),
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Password"),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return "Password needs to be atleast 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isLoding ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: theme.colorScheme.primaryContainer,
                          ),
                          child: _isLoding
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: Text(
                                    _isLogIn ? "Login" : "Signup",
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _isLoding ? null : _toggleForm,
                          child: Center(
                            child: Text(
                              _isLogIn
                                  ? "Create new account?"
                                  : "Already have an account?",
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
