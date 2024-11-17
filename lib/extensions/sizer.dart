import 'package:flutter/material.dart';

/// Get screen media.
final MediaQueryData media =
    // ignore: deprecated_member_use
    MediaQueryData.fromWindow(WidgetsBinding.instance.window);

/// This extention help us to make widget responsive.
extension NumberParsing on num {
  double get w => this * media.size.width / 428;
  double get h => this * media.size.height / 832;
}
