import 'package:flutter/foundation.dart';

class TextManager extends ChangeNotifier {
  static TextManager? _instance;
  static TextManager get instance {
    if (_instance == null) {
      _instance = TextManager();
    }
    return _instance!;
  }

  String text = "";

  void setText(String value) {
    text = value;
    notifyListeners();
  }
}