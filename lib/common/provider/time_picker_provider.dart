import 'package:flutter/material.dart';

class TimePickerProvider extends ChangeNotifier {
  TimeOfDay? _selectedTime;

  TimeOfDay? get selectedTime => _selectedTime;

  void updateSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }
}
