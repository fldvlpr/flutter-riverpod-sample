import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mock the Repository again!
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  // A helper function to wrap our screen with the required Flutter/Riverpod boilerplate
  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        // INTERCEPT: Give the UI our fake repository!
        todoRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: HomeScreen(), // The screen we actually want to test
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('shows loading indicator initially, then displays todos', (
      tester,
    ) async {
      // 1. Arrange
      final fakeTodos = [
        Todo(id: 1, userId: 1, title: 'Buy groceries', completed: false),
        Todo(id: 2, userId: 1, title: 'Walk the dog', completed: true),
      ];
      when(() => mockRepository.getTodos()).thenAnswer((_) async => fakeTodos);

      // 2. Act: Render the widget
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Assert (Loading State)
      // The exact moment we pump the widget, the Future hasn't finished yet.
      // So, our Riverpod state is `.loading()`, and we should see our loader!
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 4. Act: Wait for the FutureProvider to resolve and trigger a rebuild
      await tester.pumpAndSettle();

      // 5. Assert (Data State)
      // The Future resolved! The loader should be gone, and our list should be there!
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Buy groceries'), findsOneWidget);
      expect(find.text('Walk the dog'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2)); // We expect 2 rows
    });
  });
}
