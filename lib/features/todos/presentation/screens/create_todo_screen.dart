import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/todos/presentation/providers/todo_providers.dart';
import 'package:go_router/go_router.dart';

// 1. Change to ConsumerStatefulWidget
class CreateTodoScreen extends ConsumerStatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  ConsumerState<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends ConsumerState<CreateTodoScreen> {
  // 2. Add our Form Key and Controller inside the State
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 3. Wrap everything in a Form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 4. Change TextField to TextFormField to unlock the validator!
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Todo Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title'; // The error message!
                  }
                  return null; // Valid!
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // 5. Trigger the form validation!
                  if (_formKey.currentState!.validate()) {
                    final title = _controller.text.trim();
                    await ref.read(todoListProvider.notifier).addTodo(title);
                    
                    if (context.mounted) {
                       if (context.canPop()) {
                        context.pop();
                      }
                    }
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
