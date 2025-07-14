import 'package:flutter/material.dart';
import 'package:kods/services_screens/modules/electrician/model/electrician_model.dart';

enum BookingStatus {pending, confirmed, inProgress, completed, cancelled}

class Booking {
  final String id;
  final ElectricalService service;
  final ElectricalShop? shop;
  final DateTime bookingDate;
  final TimeOfDay bookingTime;
  final DateTime createdAt;
  final BookingStatus status;
  final String? notes;
  final String? cancellationReason;

  Booking({
    required this.id,
    required this.service,
    this.shop,
    required this.bookingDate,
    required this.bookingTime,
    required this.createdAt,
    required this.status,
    this.notes,
    this.cancellationReason,
  });

  String get formattedBookingDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${bookingDate.day} ${months[bookingDate.month - 1]}, ${bookingDate.year}';
  }

  String get formattedBookingTime {
    final hour = bookingTime.hour;
    final minute = bookingTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.inProgress:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.teal;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  bool get canBeCancelled {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      service: ElectricalService.fromJson(json['service']),
      shop: json['shop'] != null ? ElectricalShop.fromJson(json['shop']) : null,
      bookingDate: DateTime.parse(json['bookingDate']),
      bookingTime: TimeOfDay(
        hour: json['bookingTime']['hour'],
        minute: json['bookingTime']['minute'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'],
      cancellationReason: json['cancellationReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service.toJson(),
      'shop': shop?.toJson(),
      'bookingDate': bookingDate.toIso8601String(),
      'bookingTime': {
        'hour': bookingTime.hour,
        'minute': bookingTime.minute,
      },
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'notes': notes,
      'cancellationReason': cancellationReason,
    };
  }
}