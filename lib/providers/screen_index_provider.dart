import 'package:flutter/material.dart';

class screenIndexProvider extends ChangeNotifier {
  int screenIndex = 0;
  int previousScreenIndex = 0;
  // Initial index of the screen
  int maxIndexonNavBar = 2;
  // function to return the current screen Index
  int get fetchCurrentScreenIndex => screenIndex;
  int get fetchPreviousScreenIndex => previousScreenIndex;
  int get fetchMaxItems => maxIndexonNavBar;

  void updateScreenIndex(int newIndex) {
    // function to update the screenIndex
    previousScreenIndex = screenIndex;
    screenIndex = newIndex;
    notifyListeners(); // This will notify every listeners that the screen index has been changed
  }
}
