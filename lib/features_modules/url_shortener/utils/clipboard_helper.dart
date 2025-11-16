import 'package:flutter/services.dart';

class ClipboardHelper {
  ClipboardHelper._();

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
