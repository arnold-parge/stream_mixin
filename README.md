# stream_mixin

A simple mixin for adding a stream behaviour to any class object.

## Intention

The intention for this package is, instead of using state, we can use this package for streaming data from our controller/adapter/service to the widgets, which will result in better performance and cleaner code.

## Getting Started
To subscribe a class instance, create the class with `StreamMixin`

### Create a service class

```dart
class AppTagService with StreamMixin<String> {
  AppTagService._();
  static final AppTagService instance = AppTagService._();
}
```

### Subscribe to change of the tag service

```dart
class CurrentTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      builder: (context, snap) => Text(snap.data ?? 'No tag selected yet.'),
      stream: AppTagService.instance.onChange, //⭐
    );
  }
}
```

### Change current tag

Note, tag can be changed from any place in the app because it does not need context or state.

```dart
someFunction() {
  AppTagService.instance.update('COVID-19');
}
```

## Check example folder for more examples

### PS 
- PRs are welcome
- Please raise issues on https://github.com/arnold-parge/screen_loader.
- Open for suggestions ❤️
