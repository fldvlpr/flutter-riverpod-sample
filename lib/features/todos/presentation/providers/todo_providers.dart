import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';

class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    final repository = ref.watch(todoRepositoryProvider);

    return repository.getTodos();
  }

  // A method we can call from the UI to add a new Todo
  Future<void> addTodo(String title) async {
    // 1. Set the state to loading
    state = const AsyncValue.loading();

    // 2. AsyncValue.guard automatically handles try/catch for us!
    state = await AsyncValue.guard(() async {
      // Notice we use ref.read() here instead of ref.watch() because we are inside a function
      final repository = ref.read(todoRepositoryProvider);
      final newTodo = await repository.createTodo(title);

      // 3. Append the new Todo to our existing list and return it to update the UI
      return [...?state.value, newTodo];
    });
  }
}

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Todo>>(
  () {
    return TodoListNotifier();
  },
);

final todoDetailProvider = FutureProvider.family<Todo, int>((ref, id) async {
  return ref.watch(todoRepositoryProvider).getTodoById(id);
});
