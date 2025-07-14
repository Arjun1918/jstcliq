import 'package:flutter/material.dart';
import 'package:kods/menu_drawer/booking/model/booking_model.dart';
import 'package:kods/menu_drawer/booking/provider/booking_provider.dart';
import 'package:kods/services_screens/modules/electrician/model/electrician_model.dart';
import 'package:kods/services_screens/modules/electrician/repo/electrician_repo.dart';

class ElectricalProvider extends ChangeNotifier {
  List<ElectricalShop> _shops = [];
  List<ElectricalService> _services = [];
  bool _isLoading = false;
  bool _isBookingLoading = false;
  String? _error;
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  BookingProvider? _bookingProvider;

  List<ElectricalShop> get shops => _shops;
  List<ElectricalService> get services => _services;
  bool get isLoading => _isLoading;
  bool get isBookingLoading => _isBookingLoading;
  String? get error => _error;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  
  bool get canBookService => _selectedDate != null && _selectedTime != null && !_isBookingLoading;

  void setBookingProvider(BookingProvider bookingProvider) {
    _bookingProvider = bookingProvider;
  }

  Future<void> loadElectricalShops() async {
    _setLoading(true);
    _error = null;
    
    try {
      _shops = await ElectricalDataService.getAllElectricalShops();
    } catch (e) {
      _error = 'Failed to load electrical shops: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadServicesForShop(String shopId) async {
    _setLoading(true);
    _error = null;
    
    try {
      _services = await ElectricalDataService.getServicesForShop(shopId);
    } catch (e) {
      _error = 'Failed to load services: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAllElectricalServices() async {
    _setLoading(true);
    _error = null;
    
    try {
      _services = await ElectricalDataService.getAllElectricalServices();
    } catch (e) {
      _error = 'Failed to load electrical services: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchShopsByLocation(String location) async {
    _setLoading(true);
    _error = null;
    
    try {
      _shops = await ElectricalDataService.searchShopsByLocation(location);
    } catch (e) {
      _error = 'Failed to search shops: $e';
    } finally {
      _setLoading(false);
    }
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay? time) {
    _selectedTime = time;
    notifyListeners();
  }

Future<void> confirmBooking({
  required ElectricalService service,
  ElectricalShop? shop,
}) async {
  if (_selectedDate == null || _selectedTime == null) {
    _error = 'Please select both date and time';
    notifyListeners();
    return;
  }

  _setBookingLoading(true);
  
  try {
    await Future.delayed(const Duration(seconds: 2));
    
    final bookingId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final booking = Booking(
      id: bookingId,
      service: service,
      shop: shop,
      bookingDate: _selectedDate!,
      bookingTime: _selectedTime!,
      createdAt: DateTime.now(),
      status: BookingStatus.confirmed,
    );
    
    if (_bookingProvider != null) {
      await _bookingProvider!.addBooking(booking);
    }
    
    // Clear the booking state after successful booking
    clearBookingState();
    
    // THIS WAS MISSING - notify listeners about the booking completion
    notifyListeners();
    
  } catch (e) {
    _error = 'Failed to confirm booking: $e';
    rethrow;
  } finally {
    _setBookingLoading(false);
  }
}
  void clearBookingState() {
    _selectedDate = null;
    _selectedTime = null;
    _isBookingLoading = false;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setBookingLoading(bool loading) {
    _isBookingLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearData() {
    _shops.clear();
    _services.clear();
    _error = null;
    _isLoading = false;
    _isBookingLoading = false;
    _selectedDate = null;
    _selectedTime = null;
    notifyListeners();
  }
}