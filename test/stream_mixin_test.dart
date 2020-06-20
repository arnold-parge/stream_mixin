import 'package:flutter_test/flutter_test.dart';

import 'package:stream_mixin/stream_mixin.dart';

class AppTagService with StreamMixin<String> {
  AppTagService._();
  static final AppTagService instance = AppTagService._();

  @override
  void change(String item) {
    print('changed to: $item');
    super.change(item);
  }
}

void main() {
  test('adds one to input values', () {
    List<String> stringsToEmit = ['Arnold', 'Simon', 'Parge'];

    expect(
      AppTagService.instance.onChange,
      emitsInOrder(stringsToEmit),
    );

    stringsToEmit.forEach((str) => AppTagService.instance.change(str));
  });
}
