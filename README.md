# stream_mixin

Data management using stream to avoid use of State/setState/StatefulWidget, boosting the performance and code separation.

---
## Breaking change in 2.0.0 and 3.0.0. Check the [changelog](/changelog).

---
## The Intention

The intention for this package is, instead of using state, use this package for streaming data from the controller/adapter/service to the widgets, which results in better performance and cleaner code.

## Basic example
```dart
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
```

## [Check all examples](/example)

## Contribute ❤️
There are couple of ways in which you can contribute.
- Propose any feature, enhancement
- Report a bug
- Fix a bug
- Participate in a discussion and help in decision making
- Write and improve some documentation. Documentation is super critical and - its importance cannot be overstated!
- Send in a Pull Request 🙂