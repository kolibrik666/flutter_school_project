import 'package:flutter/foundation.dart';

/// Model (dátová trieda) pre jednu úlohu
class MyTodo {
  int id;
  String name;
  bool completed;
  TodoPriority priority;

  MyTodo({
    required this.id,
    required this.name,
    this.completed = false,
    required this.priority,
  });
}

/// Enum – úrovne priority
enum TodoPriority { Low, Normal, High }

class TodoProvider extends ChangeNotifier {
  final List<MyTodo> _todos = [];

  // Aktuálna vybraná priorita (používa sa pri pridávaní novej úlohy)
  TodoPriority priority = TodoPriority.Normal;

  List<MyTodo> get todos => List.unmodifiable(_todos);

  void setPriority(TodoPriority p) {
    priority = p;
    notifyListeners();
  }

  void addTodo(String name) {
    if (name.isEmpty) return;
    final todo = MyTodo(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      priority: priority,
    );
    _todos.add(todo);
    // reset priority na predvolenú
    priority = TodoPriority.Normal;
    notifyListeners();
  }

  void toggleTodoStatus(int index, bool value) {
    if (index < 0 || index >= _todos.length) return;
    _todos[index].completed = value;
    notifyListeners();
  }

  void removeTodo(int index) {
    if (index < 0 || index >= _todos.length) return;
    _todos.removeAt(index);
    notifyListeners();
  }
}