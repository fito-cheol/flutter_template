import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 이 예시에서는 TodoInput 위젯에서 할 일을 입력하고, Firestore에 저장합니다.
//TodoList 위젯에서는 Firestore에서 할 일 목록을 가져와 보여주며,
//체크박스를 통해 완료 여부를 수정할 수 있습니다.

class TodoInput extends StatefulWidget {
  const TodoInput({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  final _todoController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                hintText: '할 일을 입력하세요',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addTodo();
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo() {
    final todo = _todoController.text.trim();
    if (todo.isNotEmpty) {
      _firestore.collection('todos').add({'title': todo, 'completed': false});
      _todoController.clear();
    }
  }
}
