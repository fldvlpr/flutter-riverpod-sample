import 'package:flutter_riverpod_sample/core/network/api_client.dart';
import 'package:flutter_riverpod_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late TodoRepository todoRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    todoRepository = TodoRepository(mockApiClient);
  });

  group('Todo Respository', () {
    test('should return a list of todos on success', () async {
      // 1. Arrange
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => [
          {'id': 1, 'title': 'Test', 'completed': false, 'userId': 1},
        ],
      );

      // 2. Act
      final todos = await todoRepository.getTodos();

      // 3. Assert
      expect(todos, isNotEmpty);
      expect(todos[0].id, 1);
      expect(todos[0].title, 'Test');
      expect(todos[0].completed, false);
      expect(todos[0].userId, 1);
    });

    test('should return an error on failure', () async {
      // 1. Arrange
      when(() => mockApiClient.get(any())).thenThrow(Exception('error'));

      // 2. Act & Assert
      expect(
        todoRepository.getTodos(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
