import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/network/api_client.dart';
import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';

class TodoRepository {
  final ApiClient _apiClient;

  TodoRepository(this._apiClient);

  Future<List<Todo>> getTodos() async {
    final data = await _apiClient.get('/todos');
    // We cast it to a List and map it to our Freezed models
    return (data as List).map((json) => Todo.fromJson(json)).toList();
  }

  Future<Todo> getTodoById(int id) async {
    final data = await _apiClient.get('/todos/$id');
    return Todo.fromJson(data);
  }

  Future<Todo> createTodo(String title) async {
    final data = await _apiClient.post('/todos', {
      'title': title,
      'completed': false,
      'userId': 1, // hardcoded user for the dummy API
    });
    return Todo.fromJson(data);
  }
}

// We use 'ref.watch' to grab the ApiClient, and pass it to our Repository.
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository(ref.watch(apiClientProvider));
});
