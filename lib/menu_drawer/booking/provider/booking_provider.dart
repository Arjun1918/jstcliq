import 'package:flutter/material.dart';
import 'package:kods/menu_drawer/booking/model/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;
  List<Booking> get bookings => _bookings;
  bool get isUpdating => _isUpdating;
  bool get isLoading => _isLoading;
  String? get error => _error;


  List<Booking> get upcomingBookings => _bookings
      .where(
        (booking) =>
            booking.status == BookingStatus.pending ||
            booking.status == BookingStatus.confirmed,
      )
      .toList();

  List<Booking> get pastBookings => _bookings
      .where(
        (booking) =>
            booking.status == BookingStatus.completed ||
            booking.status == BookingStatus.cancelled,
      )
      .toList();

  Future<void> loadBookings() async {
  }

  Future<void> addBooking(Booking booking) async {
    _bookings.insert(0, booking);

    _bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));


    notifyListeners();
  }

  Future<void> refreshBookings() async {
    _setLoading(true);
    _error = null;

    try {      await Future.delayed(const Duration(seconds: 1));

      _bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = 'Failed to refresh bookings: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    _setUpdating(true);
    _error = null;

    try {
      await Future.delayed(const Duration(seconds: 1));

      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        final booking = _bookings[index];
        if (booking.canBeCancelled) {
          final updatedBooking = Booking(
            id: booking.id,
            service: booking.service,
            shop: booking.shop,
            bookingDate: booking.bookingDate,
            bookingTime: booking.bookingTime,
            createdAt: booking.createdAt,
            status: BookingStatus.cancelled,
            notes: booking.notes,
            cancellationReason: reason,
          );
          _bookings[index] = updatedBooking;
          notifyListeners(
          );
        }
      }
    } catch (e) {
      _error = 'Failed to cancel booking: $e';
    } finally {
      _setUpdating(false);
    }
  }

  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus,
  ) async {
    _setUpdating(true);
    _error = null;

    try {
      await Future.delayed(const Duration(seconds: 1));

      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        final booking = _bookings[index];
        final updatedBooking = Booking(
          id: booking.id,
          service: booking.service,
          shop: booking.shop,
          bookingDate: booking.bookingDate,
          bookingTime: booking.bookingTime,
          createdAt: booking.createdAt,
          status: newStatus,
          notes: booking.notes,
          cancellationReason: booking.cancellationReason,
        );
        _bookings[index] = updatedBooking;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update booking status: $e';
    } finally {
      _setUpdating(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearBookings() {
    _bookings.clear();
    _error = null;
    notifyListeners();
  }
}
