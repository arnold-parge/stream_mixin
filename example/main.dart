import 'package:flutter/material.dart';
import 'package:stream_mixin/store_service.dart';
import 'package:stream_mixin/stream_mixin.dart';

// Example 1

class CountService with StreamMixin<int> {
  increment() {
    update(lastUpdate ?? 0 + 1);
  }
}

/// You can either create a global instance of CountService or create a
/// singleton like class by adding the following in CountService class
/// ```dart
///   CountService._();
///   static CountService instance = CountService._();
/// ```
final countService = CountService();

anywhereInTheApp() {
  countService.increment();
}

Widget someWidget() {
  return StreamBuilder<int>(
    stream: countService.onChange,
    builder: (cxt, snap) => Text((snap.data ?? 0).toString()),
  );
}

// Example 2

class TodoModel extends BaseModel {
  String title;
  bool completed;

  TodoModel({
    required String id,
    required this.title,
    this.completed = false,
  }) : super(id: id);
}

class TodoService extends StoreService<TodoModel> {
  TodoService._();
  static TodoService store = TodoService._();

  List<TodoModel> get completed {
    return values.where((todo) => todo.completed).toList();
  }

  List<TodoModel> get pending {
    return values.where((todo) => !todo.completed).toList();
  }

  void toggleStatus(TodoModel todo) {
    todo.completed = !todo.completed;
    store.update(todo);
  }
}

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snap) => ListView(
        children: TodoService.store.values.map(_buildListTile).toList(),
      ),
      stream: TodoService.store.onChange,
    );
  }

  ListTile _buildListTile(TodoModel todo) {
    return ListTile(
      leading: Text(todo.id.toString()),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration:
              todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: Checkbox(
        value: todo.completed,
        onChanged: (bool? _) {
          TodoService.store.toggleStatus(todo);
        },
      ),
    );
  }
}
