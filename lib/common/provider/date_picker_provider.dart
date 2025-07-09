import 'package:flutter/material.dart';

class DatePickerProvider extends ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
