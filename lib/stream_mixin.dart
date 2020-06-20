library stream_mixin;

import 'dart:async';

/// To make a class subscribable use the class with [StreamMixin]
///
/// eg:
///
/// ### Create a service
/// ```dart
/// class AppTagService with StreamMixin<String> {
///   AppTagService._();
///   static final AppTagService instance = AppTagService._();
/// }
/// ```
///
/// ### Subscribe to change of the tag service
/// ```dart
/// class CurrentTag extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return StreamBuilder<String>(
///       builder: (context, snap) => Text(snap.data),
///       stream: AppTagService.instance.onChange,
///     );
///   }
/// }
/// ```
///
/// ### Change current tag
/// Note, tag can be changed from any place in the app because it does not need context or state.
/// ```dart
/// someFunction() {
///   AppTagService.instance.change('COVID-19');
/// }
/// ```
mixin StreamMixin<T> {
  StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get onChange {
    return _controller.stream.asBroadcastStream();
  }

  void change(T item) {
    _controller.add(item);
  }
}
