import 'dart:ui';

class OrderStatus {
  final String id;
  final String bookingId;
  final OrderStatusType status;
  final String serviceName;
  final String customerName;
  final String customerAddress;
  final DateTime scheduledDate;
  final String scheduledTime;
  final Electrician? assignedElectrician;
  final String? estimatedArrival;
  final String? workDescription;
  final List<StatusUpdate> statusUpdates;
  final double totalAmount;
  final PaymentStatus paymentStatus;

  OrderStatus({
    required this.id,
    required this.bookingId,
    required this.status,
    required this.serviceName,
    required this.customerName,
    required this.customerAddress,
    required this.scheduledDate,
    required this.scheduledTime,
    this.assignedElectrician,
    this.estimatedArrival,
    this.workDescription,
    required this.statusUpdates,
    required this.totalAmount,
    required this.paymentStatus,
  });

  String get formattedDate => "${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}";
  String get formattedAmount => "₹${totalAmount.toStringAsFixed(0)}";
  
  Color get statusColor {
    switch (status) {
      case OrderStatusType.pending:
        return const Color(0xFFFF9800);
      case OrderStatusType.confirmed:
        return const Color(0xFF2196F3);
      case OrderStatusType.enRoute:
        return const Color(0xFF9C27B0);
      case OrderStatusType.arrived:
        return const Color(0xFF4CAF50);
      case OrderStatusType.inProgress:
        return const Color(0xFF607D8B);
      case OrderStatusType.completed:
        return const Color(0xFF4CAF50);
      case OrderStatusType.cancelled:
        return const Color(0xFFFF5252);
    }
  }

  String get statusText {
    switch (status) {
      case OrderStatusType.pending:
        return "Pending";
      case OrderStatusType.confirmed:
        return "Confirmed";
      case OrderStatusType.enRoute:
        return "En Route";
      case OrderStatusType.arrived:
        return "Arrived";
      case OrderStatusType.inProgress:
        return "In Progress";
      case OrderStatusType.completed:
        return "Completed";
      case OrderStatusType.cancelled:
        return "Cancelled";
    }
  }
}

class Electrician {
  final String id;
  final String name;
  final String phoneNumber;
  final String profileImage;
  final double rating;
  final int experienceYears;
  final String specialization;
  final String? currentLocation;

  Electrician({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profileImage,
    required this.rating,
    required this.experienceYears,
    required this.specialization,
    this.currentLocation,
  });

  String get formattedPhone => "+91 ${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}";
  String get formattedRating => rating.toStringAsFixed(1);
}

class StatusUpdate {
  final String id;
  final String message;
  final DateTime timestamp;
  final OrderStatusType status;

  StatusUpdate({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  String get formattedTime => "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
}

enum OrderStatusType {
  pending,
  confirmed,
  enRoute,
  arrived,
  inProgress,
  completed,
  cancelled,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
}

