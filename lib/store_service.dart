import 'dart:async';

/// Can be used to specify the type of operation you want to perform on the data in the store
enum Operation {
  /// Should be used when adding some data in the store
  add,

  /// Should be used when updating some data in the store
  update,

  /// Should be used when deleting some data in the store
  delete,
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
abstract class StoreService<T extends BaseModel> {
  final StreamController<StreamElement<T>> _controller =
      StreamController<StreamElement<T>>.broadcast();

  /// Returns a [Stream] of [StreamElement] of [T]
  Stream<StreamElement<T>> get onChange {
    return _controller.stream.asBroadcastStream();
  }

  /// Pushes [item] in the [Stream]
  void _update(StreamElement<T> element) {
    _controller.add(element);
  }

  /// The main in-memory store which will store your model extended by [BaseModel]
  final Map<String, T> _inMemoryStore = {};

  /// Adds an item in the store
  void _add(T item) {
    _inMemoryStore.update(item.id, (update) => item, ifAbsent: () => item);
  }

  /// Deletes an item from the store
  void _delete(T item) {
    _inMemoryStore.remove(item.id);
  }

  /// Returns list of items from the store
  List<T> get values {
    return _inMemoryStore.values.toList();
  }

  /// Checks if the the item exist by this [id]
  bool idExist(String id) {
    return _inMemoryStore.containsKey(id);
  }

  /// Finds and returns the item by [id]
  /// If the item is not found, null will be returned
  T? getById(String id) {
    return _inMemoryStore[id];
  }

  // Find a better way to force emit event without element in updateAll.
  // Hence, commenting updateAll

  /// Updates all records in the store
  // void updateAll(T Function(String, T) update) {
  //   _inMemoryStore.updateAll(update);
  //   _update();
  // }

  /// Adds an [item] to the store.
  void add(T item) {
    _add(item);
    _update(StreamElement(item: item, operation: Operation.add));
  }

  /// Updates an [item] in the store.
  void update(T item) {
    _add(item);
    _update(StreamElement(item: item, operation: Operation.update));
  }

  /// Deletes an [item] from the store.
  void delete(T item) {
    _delete(item);
    _update(StreamElement(item: item, operation: Operation.delete));
  }

  /// Deletes an [item] from the store by the given id.
  void deleteItemById(String id) {
    var item = getById(id);
    if (item != null) {
      _delete(item);
      _update(StreamElement(item: item, operation: Operation.delete));
    }
  }
}
