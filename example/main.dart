import 'package:flutter/material.dart';

import '../lib/stream_mixin.dart';

class AppTagService with StreamMixin<String> {
  AppTagService._();
  static final AppTagService instance = AppTagService._();
}

class CurrentTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      builder: (context, snap) => Text(snap.data),
      stream: AppTagService.instance.onChange, //⭐
    );
  }
}

someFunction() {
  AppTagService.instance.change('COVID-19');
}