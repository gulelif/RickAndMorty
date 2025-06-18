import 'package:flutter/material.dart';

class GlobalUpdateNotifier extends ChangeNotifier {
  void updateAllPages() {
    notifyListeners(); // Tüm dinleyicilere haber ver
  }
}
