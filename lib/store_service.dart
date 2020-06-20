import 'package:stream_mixin/stream_mixin.dart';
import 'package:meta/meta.dart';

enum Operation { Add, Update, Delete }

class AppStreamElement<T> {
  final T item;
  final Operation operation;

  AppStreamElement({@required this.item, @required this.operation});
}

class BasicModel {
  int id;
  BasicModel({int id});
}

abstract class StoreService<T extends BasicModel>
    with StreamMixin<AppStreamElement<T>> {
  Map<int, T> _store = {};

  void _add(T item) {
    _store.update(item.id, (update) => item, ifAbsent: () => item);
  }

  void _delete(T item) {
    _store.remove(item.id);
  }

  List<T> get values {
    return _store.values.toList();
  }

  bool idExist(int id) {
    return _store.containsKey(id);
  }

  @override
  void update(AppStreamElement<T> element) {
    if (element != null) {
      switch (element.operation) {
        case Operation.Add:
        case Operation.Update:
          _add(element.item);
          break;
        case Operation.Delete:
          _delete(element.item);
          break;
        default:
          break;
      }
    }
    super.update(element);
  }
}
