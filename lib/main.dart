import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'todo.dart';
import 'todo_list.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todoBox');

  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoList(Hive.box<Todo>('todoBox')),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List with Hive',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Consumer<TodoList>(
        builder: (context, todoList, child) {
          return ListView.builder(
            itemCount: todoList.todos.length,
            itemBuilder: (context, index) {
              final todo = todoList.todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => todoList.removeTodo(index),
                ),
                onTap: () => todoList.toggleTodoStatus(index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add To-Do'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter todo title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        Provider.of<TodoList>(context, listen: false)
                            .addTodo(_controller.text);
                        _controller.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
