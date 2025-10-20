import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

/// Hlavná stránka aplikácie so zoznamom úloh (To-Do list)
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // Kontrolér na prístup k hodnote z TextFieldu
  final _controller = TextEditingController();

  /// Funkcia, ktorá sa zavolá pri kliknutí na "SAVE"
  /// – pridá novú úlohu do zoznamu (pomocou Provideru)
  void _addTodo(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    if (_controller.text.isEmpty) {
      showMsg(context, 'Input field must not be empty');
      return;
    }

    provider.addTodo(_controller.text);
    _controller.clear();
    Navigator.pop(context);
  }

  /// Zmena stavu úlohy (označenie ako splnená / nesplnená)
  void _toggleTodoStatus(BuildContext context, int index, bool value) {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    provider.toggleTodoStatus(index, value);
  }

  /// Hlavné rozloženie obrazovky
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Umiestnenie tlačidla v strede dole
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Tlačidlo na pridanie úlohy
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoSheet();
        },
        child: const Icon(Icons.add),
      ),

      // Horný AppBar s názvom
      appBar: AppBar(title: const Text('My Todos')),

      // Obsah obrazovky – buď text, alebo zoznam úloh
      body: Consumer<TodoProvider>(
        builder: (context, provider, _) {
          final todos = provider.todos;
          if (todos.isEmpty) {
            return const Center(child: Text('Nothing to do!'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Dismissible(
                key: ValueKey(todo.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  provider.removeTodo(index);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: TodoItem(
                  todo: todo,
                  onChanged: (value) => _toggleTodoStatus(context, index, value),
                  onDelete: () => provider.removeTodo(index),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Zobrazí spodné okno (BottomSheet) na pridanie novej úlohy
  void _showAddTodoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'What to do?'),
            ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Select Priority'),
            ),

            Consumer<TodoProvider>(
              builder: (context, provider, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<TodoPriority>(
                    value: TodoPriority.Low,
                    groupValue: provider.priority,
                    onChanged: (value) {
                      if (value != null) provider.setPriority(value);
                    },
                  ),
                  const Text('Low'),

                  Radio<TodoPriority>(
                    value: TodoPriority.Normal,
                    groupValue: provider.priority,
                    onChanged: (value) {
                      if (value != null) provider.setPriority(value);
                    },
                  ),
                  const Text('Normal'),

                  Radio<TodoPriority>(
                    value: TodoPriority.High,
                    groupValue: provider.priority,
                    onChanged: (value) {
                      if (value != null) provider.setPriority(value);
                    },
                  ),
                  const Text('High'),
                ],
              ),
            ),

            // Tlačidlo na uloženie úlohy
            ElevatedButton(
              onPressed: () => _addTodo(context),
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}


void showMsg(BuildContext context, String s) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Caution!'),
      content: Text(s),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
      ],
    ),
  );
}

class TodoItem extends StatelessWidget {
  final MyTodo todo;
  final Function(bool) onChanged;
  final VoidCallback onDelete;

  const TodoItem({super.key, required this.todo, required this.onChanged, required this.onDelete});

  Color _priorityColor(TodoPriority p) {
    switch (p) {
      case TodoPriority.Low:
        return Colors.green;
      case TodoPriority.Normal:
        return Colors.orange;
      case TodoPriority.High:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(todo.name),
      subtitle: Text('Priority: ${todo.priority.name}',
          style: TextStyle(color: _priorityColor(todo.priority))),
      value: todo.completed,
      onChanged: (value) {
        onChanged(value!);
      },
      secondary: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
