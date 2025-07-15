import 'package:kods/menu_drawer/order_status/model/order_status.dart';

class DummyOrderData {
  static OrderStatus getSampleOrder() {
    return OrderStatus(
      id: "ORD001",
      bookingId: "BK2024001",
      status: OrderStatusType.enRoute,
      serviceName: "Electrical Repair & Maintenance",
      customerName: "John Smith",
      customerAddress: "123 Main Street, Koramangala, Bangalore - 560034",
      scheduledDate: DateTime.now().add(const Duration(hours: 2)),
      scheduledTime: "2:00 PM - 4:00 PM",
      assignedElectrician: Electrician(
        id: "ELC001",
        name: "Rajesh Kumar",
        phoneNumber: "9876543210",
        profileImage: "assets/images/plumber.jpeg",
        rating: 4.8,
        experienceYears: 8,
        specialization: "Home Electrical Systems",
        currentLocation: "5 km away from your location",
      ),
      estimatedArrival: "15-20 minutes",
      workDescription: "Fix electrical wiring issues in kitchen and living room",
      statusUpdates: [
        StatusUpdate(
          id: "SU001",
          message: "Booking confirmed. Electrician will arrive as scheduled.",
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          status: OrderStatusType.confirmed,
        ),
        StatusUpdate(
          id: "SU002",
          message: "Electrician is on the way to your location.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          status: OrderStatusType.enRoute,
        ),
      ],
      totalAmount: 1200.0,
      paymentStatus: PaymentStatus.pending,
    );
  }
}