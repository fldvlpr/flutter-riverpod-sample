import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter_riverpod_sample/features/profile/presentation/profile_screen.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/screens/create_todo_screen.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/screens/home_screen.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/screens/todo_detail_screen.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // The ShellRoute handles our BottomNavigationBar tabs!
      ShellRoute(
        builder: (context, state, child) {
          return DashboardScreen(child: child);
        },
        routes: [
          // 1. The Home Route
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

          // 2. The Profile Route
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // These routes are OUTSIDE the ShellRoute because we want them to
      // take up the full screen (no bottom navigation bar).
      GoRoute(path: '/create', builder: (context, state) => CreateTodoScreen()),
      GoRoute(
        path: '/todo/:id',
        builder: (context, state) {
          // We grab the :id from the URL string and pass it to our widget!
          final idString = state.pathParameters['id']!;
          return TodoDetailScreen(todoId: int.parse(idString));
        },
      ),
    ],
  );
});
