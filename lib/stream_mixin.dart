library stream_mixin;

import 'dart:async';

/// To subscribe a class instance, create the class with [StreamMixin]
///
/// (Check the package for example)
mixin StreamMixin<T> {
  T? lastUpdate;
  StreamController<T> _controller = StreamController<T>.broadcast();

  /// Returns a [Stream] of [T]
  Stream<T> get onChange {
    return _controller.stream.asBroadcastStream();
  }

  /// Pushes data in the [Stream]
  void update({required T element}) {
    this.lastUpdate = element;
    _controller.add(element);
  }
}
