import 'package:flutter_riverpod_sample/features/todos/domain/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Todo", () {
    test('should parse json properly', () {
      // 1. Arrange
      final jsonMap = {
        'id': 1,
        'title': 'Test',
        'completed': false,
        'userId': 1,
      };

      // 2. Act
      final todo = Todo.fromJson(jsonMap);

      // 3. Assert
      expect(todo.id, 1);
      expect(todo.title, 'Test');
      expect(todo.completed, false);
      expect(todo.userId, 1);
    });

    test('should handle missing completed field to default false value', () {
      // 1. Arrange
      final jsonMap = {
        'id': 1,
        'title': 'Test',
        'userId': 1,
      };

      // 2. Act
      final todo = Todo.fromJson(jsonMap);

      // 3. Assert
      expect(todo.completed, false);
    });
  });
}
