// main_view.dart
import 'package:flutter/material.dart';
import 'todoList.dart';
import 'todoInput.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});
  static const routeName = '/firebase/todo';

  @override
  State<TodoView> createState() => _TodoView();
}

class _TodoView extends State<TodoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main View'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: TodoInput(), // TodoList 위젯 렌더링
          ),
          Expanded(
            child: TodoList(), // NoteList 위젯 렌더링
          ),
        ],
      ),
    );
  }
}
