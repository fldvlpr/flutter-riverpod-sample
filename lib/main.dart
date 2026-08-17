import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/router/app_router.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

// Change StatelessWidget to ConsumerWidget
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  // Add WidgetRef ref to the build method
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the router we just created
    final router = ref.watch(goRouterProvider);

    // Use MaterialApp.router instead of just MaterialApp
    return MaterialApp.router(
      title: 'Riverpod Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router, // Pass the router here!
    );
  }
}
