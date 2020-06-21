import 'package:stream_mixin/stream_mixin.dart';
import 'package:meta/meta.dart';

/// Can be used to specify the type of operation you want to perform on the data in the store
enum Operation {
  /// Should be used when adding some data in the store
  Add,

  /// Should be used when updating some data in the store
  Update,

  /// Should be used when deleting some data in the store
  Delete,
}

/// Tells [StoreService] what [Operation] to perform and on which [item] to perform the operation
class AppStreamElement<T> {
  final T item;
  final Operation operation;

  AppStreamElement({@required this.item, @required this.operation});
}

/// A model that should be extended by models that will use in [StoreService]
abstract class BasicModel {
  int id;
  BasicModel({int id});
}

/// [StoreService] will let you create a service which will handle most of the operations on the model out of the box,
/// like [idExist], [onChange], [update()], [updateAll()], [values]
abstract class StoreService<T extends BasicModel>
    with StreamMixin<AppStreamElement<T>> {
  /// The main in memory store which will store your model extended by [BasicModel]
  Map<int, T> _store = {};

  /// Adds an item in the store
  void _add(T item) {
    _store.update(item.id, (update) => item, ifAbsent: () => item);
  }

  /// Deletes an item from the store
  void _delete(T item) {
    _store.remove(item.id);
  }

  /// Returns list of items from the store
  List<T> get values {
    return _store.values.toList();
  }

  /// Checks if the the item exist by this [id]
  bool idExist(int id) {
    return _store.containsKey(id);
  }

  /// Updates all records in the store
  void updateAll(T Function(int, T) update) {
    _store.updateAll(update);
    super.update(element: null);
  }

  /// Updates a single record in the store
  /// 
  /// The data is handdled as per the [AppStreamElement] passed
  @override
  void update({AppStreamElement<T> element}) {
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
    super.update(element: element);
  }
}
