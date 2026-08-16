import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/models/todo_item.dart';
import 'package:todo_app_new/providers/todo_provider.dart';
import 'package:todo_app_new/widgets/home/add_edit_todo_widget.dart';

class TodoItemWidget extends ConsumerWidget {
  const TodoItemWidget({super.key, required this.item});
  final TodoItem item;

  Future<void> _delete({
    required WidgetRef ref,
    required String id,
    required BuildContext context,
  }) async {
    try {
      await ref.read(todoProvider.notifier).delete(id);
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Server error: $err")));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => AddEditTodoWidget(currentTodo: item),
        );
      },
      leading: Checkbox(
        value: item.isComplete,
        onChanged: (value) {
          ref.read(todoProvider.notifier).toggleTodoStatus(item.id, value!);
        },
      ),
      title: Text(item.title),
      trailing: IconButton(
        onPressed: () {
          _delete(context: context, ref: ref, id: item.id);
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}
