
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

abstract class ListDialogItem<T> with ChangeNotifier {

  ListDialogItem({@required this.item, selected = false}) {
    _selected = selected;
  }

  T item;
  bool _selected;
  
  bool get selected => _selected;
  String get title;

  void setSelected(bool selected) {
    this._selected = selected;
    notifyListeners();
  }

}