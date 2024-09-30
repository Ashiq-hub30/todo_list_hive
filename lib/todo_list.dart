import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'todo.dart';

class TodoList extends ChangeNotifier {
  final Box<Todo> _todoBox;

  TodoList(this._todoBox);

  List<Todo> get todos => _todoBox.values.toList();

  void addTodo(String title) {
    final todo = Todo(title: title);
    _todoBox.add(todo);
    notifyListeners();
  }

  void toggleTodoStatus(int index) {
    final todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      _todoBox.putAt(index, todo);
      notifyListeners();
    }
  }

  void removeTodo(int index) {
    _todoBox.deleteAt(index);
    notifyListeners();
  }
}
