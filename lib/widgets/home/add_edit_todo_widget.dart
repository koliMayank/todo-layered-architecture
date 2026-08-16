import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/models/todo_item.dart';
import 'package:todo_app_new/providers/todo_provider.dart';

class AddEditTodoWidget extends ConsumerStatefulWidget {
  const AddEditTodoWidget({super.key, this.currentTodo});
  final TodoItem? currentTodo;

  @override
  ConsumerState<AddEditTodoWidget> createState() => _AddEditTodoWidgetState();
}

class _AddEditTodoWidgetState extends ConsumerState<AddEditTodoWidget> {
  late TextEditingController _title;
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      if (widget.currentTodo == null) {
        await ref.read(todoProvider.notifier).addTodo(_title.text.trim());
      } else {
        await ref
            .read(todoProvider.notifier)
            .updateTodoTitle(widget.currentTodo!.id, _title.text.trim());
      }
      if (mounted) Navigator.of(context).pop();
    } catch (err) {}
  }

  void _clear() {
    setState(() {
      _title.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.currentTodo?.title ?? "");
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0 + MediaQuery.of(context).viewInsets.bottom,
          top: 28,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                autocorrect: false,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _clear,
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
