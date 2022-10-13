import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int indexNav = 0;

  changeScreen(int i) {
    indexNav = i;
    notifyListeners();
  }
}
