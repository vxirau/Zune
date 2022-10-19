//FLUTTER NATIVE
import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  bool _isFabVisible = true;

  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int i) {
    this._selectedMenuOpt = i;
    notifyListeners();
  }

  set selectedMenuOptSilent(int i) {
    this._selectedMenuOpt = i;
  }

  bool get isFABVisible {
    return this._isFabVisible;
  }

  set isFabVisible(bool i) {
    this._isFabVisible = i;
    notifyListeners();
  }

  set isFabVisibleSilent(bool i) {
    this._isFabVisible = i;
  }
}
