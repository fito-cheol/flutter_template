import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// StreamBuilder를 사용하여 Firestore의 실시간 업데이트를 반영하고,
// ListView.builder를 사용하여 할 일 목록을 렌더링합니다.
// 체크박스의 onChanged 콜백에서 _updateTodo 메서드를 호출하여
// Firestore에서 해당 문서의 completed 필드를 업데이트합니다

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _firestore = FirebaseFirestore.instance;
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Todo 목록'),
  //       ),
  //       body: const ListTile(
  //         title: Text('Todo 2'),
  //       ));
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('todos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final todos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              final title = todo['title'];
              final completed = todo['completed'];

              return ListTile(
                title: Text(title),
                trailing: Checkbox(
                  value: completed,
                  onChanged: (value) {
                    _updateTodo(todo.id, value!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateTodo(String id, bool completed) {
    _firestore.collection('todos').doc(id).update({'completed': completed});
  }
}
