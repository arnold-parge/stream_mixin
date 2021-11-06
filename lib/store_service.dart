import 'package:stream_mixin/stream_mixin.dart';

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
class StreamElement<T> {
  final T item;
  final Operation operation;

  StreamElement({required this.item, required this.operation});
}

/// A model that should be extended by models that will use in [StoreService]
abstract class BaseModel {
  String id;
  BaseModel({required this.id});
}

/// [StoreService] will let you create a service which will handle most of the
/// operations on the model out of the box,
/// like [idExist], [onChange], [update], [updateAll], [values]
abstract class StoreService<T extends BaseModel>
    with StreamMixin<StreamElement<T>> {
  /// The main in-memory store which will store your model extended by [BaseModel]
  Map<String, T> _store = {};

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

  /// Finds and returns the item by [id]
  /// If the item is not found, null will be returned
  T? getById(String id) {
    return _store[id];
  }

  /// Updates all records in the store
  void updateAll(T Function(String, T) update) {
    _store.updateAll(update);

    // TODO: Find a better way to force emit event without element
    // super.update(element: null);
  }

  /// Adds an [item] to the store.
  void addItem(T item) {
    _add(item);
    super.update(
      element: StreamElement(
        item: item,
        operation: Operation.Add,
      ),
    );
  }

  /// Updates an [item] in the store.
  void updateItem(T item) {
    _add(item);
    super.update(
      element: StreamElement(
        item: item,
        operation: Operation.Update,
      ),
    );
  }

  /// Deletes an [item] from the store.
  void deleteItem(T item) {
    _delete(item);
    super.update(
      element: StreamElement(
        item: item,
        operation: Operation.Delete,
      ),
    );
  }

  /// Deletes an [item] from the store by the given id.
  void deleteItemById(String id) {
    var item = getById(id);
    if (item != null) {
      _delete(item);
      super.update(
        element: StreamElement(
          item: item,
          operation: Operation.Delete,
        ),
      );
    }
  }
}
