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

      test('should return a single todo by id on success', () async {
      // 1. Arrange
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => {'id': 99, 'title': 'Test Single', 'completed': true, 'userId': 1},
      );

      // 2. Act
      final todo = await todoRepository.getTodoById(99);

      // 3. Assert
      expect(todo.id, 99);
      expect(todo.title, 'Test Single');
      
      // Bonus: Verify that the Repository actually asked for the correct URL!
      verify(() => mockApiClient.get('/todos/99')).called(1);
    });

    test('should create and return a new todo on success', () async {
      // 1. Arrange (Notice we are mocking the `post` method now!)
      when(() => mockApiClient.post(any(), any())).thenAnswer(
        (_) async => {'id': 100, 'title': 'New Todo', 'completed': false, 'userId': 1},
      );

      // 2. Act
      final todo = await todoRepository.createTodo('New Todo');

      // 3. Assert
      expect(todo.id, 100);
      expect(todo.title, 'New Todo');
      
      // Bonus: Verify the Repository sent the correct JSON body to the API!
      verify(() => mockApiClient.post('/todos', {
        'title': 'New Todo',
        'completed': false,
        'userId': 1,
      })).called(1);
    });
}
