import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/todo_providers.dart';
import 'package:go_router/go_router.dart';

class CreateTodoScreen extends ConsumerWidget {
  CreateTodoScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Todo Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final title = _controller.text.trim();
                if (title.isNotEmpty) {
                  // The Magic: We read the 'notifier' to access our custom addTodo method!
                  await ref.read(todoListProvider.notifier).addTodo(title);

                  // After adding, we go back to the previous screen
                  if (context.mounted) {
                    context.pop();
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
