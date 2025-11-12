import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  int _totalItems = 0;

  int get totalItems => _totalItems;

  void setTotalItems(int value) {
    _totalItems = value;
    notifyListeners();
  }

  void increase(int value) {
    _totalItems += value;
    notifyListeners();
  }

  void clear() {
    _totalItems = 0;
    notifyListeners();
  }
}
