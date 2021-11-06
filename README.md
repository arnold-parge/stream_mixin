# stream_mixin
Data management using stream to avoid use of State/setState/StatefulWidget, boosting the performance and code separation.

## Breaking change in 2.0.0 and 3.0.0. Check the changelog.

## The Intention

The intention for this package is, instead of using state, use this package for streaming data from the controller/adapter/service to the widgets, which results in better performance and cleaner code.

## Basic example

A basic example of a counter service that increments the count and streams the count to the widget

```dart
class Counter with StreamMixin<int> {
  increment() {
    update((lastUpdate ?? 0) + 1);
  }
}

/// You can either create a global instance of Counter or create a
/// singleton (recommented) like class by adding the following in Counter class
/// ```dart
///   Counter._();
///   static Counter instance = Counter._();
/// ```
final counter = Counter();

anywhereInTheApp() {
  counter.increment();
}

Widget someWidget() {
  return StreamBuilder<int>(
    stream: counter.onChange,
    builder: (cxt, snap) => Text((snap.data ?? 0).toString()),
  );
}
```

## Contribute ❤️
There are couple of ways in which you can contribute.
- Propose any feature, enhancement
- Report a bug
- Fix a bug
- Participate in a discussion and help in decision making
- Write and improve some documentation. Documentation is super critical and - its importance cannot be overstated!
- Send in a Pull Request 🙂