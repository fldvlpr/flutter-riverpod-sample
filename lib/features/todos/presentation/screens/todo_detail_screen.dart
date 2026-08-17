import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/todo_providers.dart';

class TodoDetailScreen extends ConsumerWidget {
  final int todoId;

  // We require the ID to be passed in from the router!
  const TodoDetailScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The Magic: Notice how we pass '(todoId)' to the provider!
    // This triggers our FutureProvider.family
    final todoAsyncValue = ref.watch(todoDetailProvider(todoId));

    return Scaffold(
      appBar: AppBar(title: const Text('Todo Detail')),
      body: todoAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (todo) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ID: ${todo.id}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  'Title: ${todo.title}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('Completed: ${todo.completed}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
