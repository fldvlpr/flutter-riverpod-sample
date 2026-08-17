import 'package:flutter_riverpod_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. This time, we mock the Repository!
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockTodoRepository();
    
    // 2. We create a ProviderContainer and override the repository provider!
    // Now, our Notifier will automatically use the mock when it calls ref.watch!
    container = ProviderContainer(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  // tearDown runs after every test to clean up memory
  tearDown(() {
    container.dispose();
  });

  group('TodoListNotifier Tests', () {
    test('initial state loads todos from repository', () async {
      // 1. Arrange
      final fakeTodos = [Todo(id: 1, userId: 1, title: 'Test 1', completed: false)];
      when(() => mockRepository.getTodos()).thenAnswer((_) async => fakeTodos);

      // 2. Act
      // We read the '.future' of the provider to wait for it to finish its initial build() loading!
      final todos = await container.read(todoListProvider.future);

      // 3. Assert
      expect(todos.length, 1);
      expect(todos.first.title, 'Test 1');
      verify(() => mockRepository.getTodos()).called(1);
    });

    test('addTodo appends a new todo to the list', () async {
      // 1. Arrange
      final initialTodos = [Todo(id: 1, userId: 1, title: 'Test 1', completed: false)];
      final newTodo = Todo(id: 2, userId: 1, title: 'New Todo', completed: false);
      
      // We have to mock BOTH methods since our provider calls both during its lifecycle!
      when(() => mockRepository.getTodos()).thenAnswer((_) async => initialTodos);
      when(() => mockRepository.createTodo('New Todo')).thenAnswer((_) async => newTodo);

      // Wait for the initial load to finish first
      await container.read(todoListProvider.future);

      // 2. Act
      // Now we call our custom addTodo method!
      await container.read(todoListProvider.notifier).addTodo('New Todo');

      // 3. Assert
      // We read the current state (.value gets the actual list out of the AsyncValue)
      final updatedTodos = container.read(todoListProvider).value!;
      
      expect(updatedTodos.length, 2);
      expect(updatedTodos.last.title, 'New Todo');
      verify(() => mockRepository.createTodo('New Todo')).called(1);
    });    
  });

    group('TodoDetailProvider Tests', () {
    test('fetches a single todo by id', () async {
      // 1. Arrange
      final fakeTodo = Todo(id: 99, userId: 1, title: 'Detail Test', completed: false);
      
      // Tell our mock repository what to do when asked for ID 99
      when(() => mockRepository.getTodoById(99)).thenAnswer((_) async => fakeTodo);

      // 2. Act
      // We pass the ID (99) into the family provider to read it!
      final todo = await container.read(todoDetailProvider(99).future);

      // 3. Assert
      expect(todo.id, 99);
      expect(todo.title, 'Detail Test');
      verify(() => mockRepository.getTodoById(99)).called(1);
    });
  });
}
