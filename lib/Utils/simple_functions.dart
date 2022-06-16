import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleFunctions {
  SimpleFunctions();

  static dismissKeyboard({required BuildContext context}) {
    FocusScope.of(context).unfocus();
  }

  static String formatDate(String value) {
    String date = DateFormat('dd MMM yy').format(DateTime.parse(value));
    return date;
  }

  static String formatTime(String value) {
    String time = DateFormat('hh: mm a').format(DateTime.parse(value).toLocal());
    return time;
  }

  static String? replaceWhitespacesUsingRegex(String s, String replace) {
    if (s == null) {
      return null;
    }

    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more
    final pattern = RegExp('\\s+');
    return s.replaceAll(pattern, replace);
  }
}
