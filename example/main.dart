import 'package:flutter/material.dart';
import 'package:stream_mixin/store_service.dart';
import 'package:stream_mixin/stream_mixin.dart';

// Example 1

class AppTagService with StreamMixin<String> {
  AppTagService._();
  static final AppTagService instance = AppTagService._();
}

class CurrentTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      builder: (context, snap) => Text(snap.data ?? 'No tag selected yet.'),
      stream: AppTagService.instance.onChange, //⭐
    );
  }
}

someFunction() {
  AppTagService.instance.update(element: 'COVID-19');
}

// Example 2

class TodoModel extends BaseModel {
  String title;
  bool completed;

  TodoModel({
    required String id,
    required this.title,
    this.completed: false,
  }) : super(id: id);
}

class TodoService extends StoreService<TodoModel> {
  TodoService._();
  static TodoService store = TodoService._();

  List<TodoModel> get completed {
    return this.values.where((todo) => todo.completed).toList();
  }

  List<TodoModel> get pending {
    return this.values.where((todo) => !todo.completed).toList();
  }

  void toggleStatus(TodoModel todo) {
    todo.completed = !todo.completed;
    store.update(todo);
  }
}

class TodoListWidget extends StatelessWidget {
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
