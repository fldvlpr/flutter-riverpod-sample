import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/screens/todo_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [todoRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(
        // We pass the ID we want to test straight to the screen
        home: TodoDetailScreen(todoId: 1),
      ),
    );
  }

  testWidgets('TodoDetailScreen shows loading then data', (tester) async {
    // 1. Arrange
    final fakeTodo = Todo(
      id: 1,
      userId: 1,
      title: 'Test Detail',
      completed: true,
    );
    when(() => mockRepository.getTodoById(1)).thenAnswer((_) async => fakeTodo);

    // 2. Act
    await tester.pumpWidget(createWidgetUnderTest());

    // 3. Assert (Loading)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 4. Act (Wait for resolution)
    await tester.pumpAndSettle();

    // 5. Assert (Data)
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Title: Test Detail'), findsOneWidget);
    expect(find.text('Completed: true'), findsOneWidget);
  });
}
