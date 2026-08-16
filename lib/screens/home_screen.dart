import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/providers/todo_provider.dart';
import 'package:todo_app_new/widgets/home/add_edit_todo_widget.dart';
import 'package:todo_app_new/widgets/home/sign_out_button.dart';
import 'package:todo_app_new/widgets/home/todo_item_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: const [SignOutButton()],
      ),
      body: todoData.when(
        data: (todos) {
          if (todos.isEmpty) {
            return Center(
              child: Text(
                "Add Todo..",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.colorScheme.secondary.withValues(alpha: .6),
                ),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final item = todos[index];
              return TodoItemWidget(item: item);
            },
            itemCount: todos.length,
          );
        },
        error: (err, stack) => Center(child: Text("Error: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddEditTodoWidget(),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
      // body: todoList.isEmpty
    );
  }
}
