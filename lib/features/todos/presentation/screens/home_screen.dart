import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/todo_providers.dart';
import 'package:go_router/go_router.dart';

// Notice we extend ConsumerWidget instead of StatelessWidget!
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. We 'watch' the provider. This forces the widget to rebuild
    // whenever the state changes (loading -> data -> error).
    final todoListState = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),

      // 2. We use the `.when` method to handle the 3 possible states of AsyncValue
      body: todoListState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet.'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: (val) {}, // We won't implement update for now
                ),
                onTap: () {
                  context.push('/todo/${todo.id}');
                },
              );
            },
          );
        },
      ),

      // 3. A FloatingActionButton to create a new Todo (coming soon)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
