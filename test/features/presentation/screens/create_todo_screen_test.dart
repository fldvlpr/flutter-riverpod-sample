import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/screens/create_todo_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  Widget createWidgetUnderTest() {
    // 1. Create a mini GoRouter just for this test
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CreateTodoScreen(),
        ),
      ],
    );
    return ProviderScope(
      overrides: [todoRepositoryProvider.overrideWithValue(mockRepository)],
      // 2. Use MaterialApp.router so context.pop() works!
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('CreateTodoScreen shows validation error when input is empty', (
    tester,
  ) async {
    // 1. Arrange
    final fakeTodos = <Todo>[];
    when(() => mockRepository.getTodos()).thenAnswer((_) async => fakeTodos);

    // 2. Act (Render the widget)
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // 3. Act (Tap the Create button WITHOUT entering any text!)
    await tester.tap(find.byType(ElevatedButton));

    // We only use .pump() here instead of pumpAndSettle() because we just
    // want to trigger the UI to rebuild and show the red error text.
    await tester.pump();

    // 4. Assert
    // The test runner will literally look at the screen for this red error text!
    expect(find.text('Please enter a title'), findsOneWidget);

    // We verify that the createTodo method on the repository was NEVER called!
    verifyNever(() => mockRepository.createTodo(any()));
  });

  testWidgets('CreateTodoScreen adds todo on button press', (tester) async {
    // 1. Arrange
    final fakeTodos = <Todo>[]; // Initial list is empty
    final newTodo = Todo(id: 1, userId: 1, title: 'New Todo', completed: false);

    // The provider will initialize first, so we mock getTodos
    when(() => mockRepository.getTodos()).thenAnswer((_) async => fakeTodos);
    // Then we mock the actual creation call
    when(
      () => mockRepository.createTodo('New Todo'),
    ).thenAnswer((_) async => newTodo);

    // 2. Act (Render)
    await tester.pumpWidget(createWidgetUnderTest());

    // Wait for the provider's initial load to finish
    await tester.pumpAndSettle();

    // 3. Act (Simulate User Input)
    // The Magic: We tell the test runner to type text into our TextField!
    await tester.enterText(find.byType(TextFormField), 'New Todo');

    // Tell the test runner to tap the Create button!
    await tester.tap(find.byType(ElevatedButton));

    // Allow the async addTodo method to finish running
    await tester.pumpAndSettle();

    // 4. Assert
    // We verify the repository method was actually called with the text we typed!
    verify(() => mockRepository.createTodo('New Todo')).called(1);
  });
}
