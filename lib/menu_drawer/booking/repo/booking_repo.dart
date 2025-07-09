// import 'package:kods/menu_drawer/booking/model/booking_model.dart';

// abstract class BookingRepository {
//   Future<List<Booking>> getBookings();
//   Future<Booking> createBooking(Booking booking);
//   Future<void> cancelBooking(String bookingId, String reason);
//   Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus);
//   Future<List<Booking>> refreshBookings();
// }

// class BookingRepositoryImpl implements BookingRepository {
//   // This will hold your API service once you add it
//   // final ApiService _apiService;
  
//   // Mock data storage for now (replace with API calls later)
//   List<Booking> _mockBookings = [];

//   @override
//   Future<List<Booking>> getBookings() async {
//     try {
//       // Simulate API call delay
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       // TODO: Replace with actual API call
//       // return await _apiService.getBookings();
      
//       // For now, return mock data
//       return List.from(_mockBookings);
//     } catch (e) {
//       throw Exception('Failed to load bookings: $e');
//     }
//   }

//   @override
//   Future<Booking> createBooking(Booking booking) async {
//     try {
//       // Simulate API call delay
//       await Future.delayed(const Duration(milliseconds: 800));
      
//       // TODO: Replace with actual API call
//       // final createdBooking = await _apiService.createBooking(booking);
      
//       // For now, add to mock storage
//       _mockBookings.insert(0, booking);
//       _mockBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
//       return booking;
//     } catch (e) {
//       throw Exception('Failed to create booking: $e');
//     }
//   }

//   @override
//   Future<void> cancelBooking(String bookingId, String reason) async {
//     try {
//       // Simulate API call delay
//       await Future.delayed(const Duration(seconds: 1));
      
//       // TODO: Replace with actual API call
//       // await _apiService.cancelBooking(bookingId, reason);
      
//       // For now, update mock storage
//       final index = _mockBookings.indexWhere((booking) => booking.id == bookingId);
//       if (index != -1) {
//         final booking = _mockBookings[index];
//         if (booking.canBeCancelled) {
//           final updatedBooking = Booking(
//             id: booking.id,
//             service: booking.service,
//             shop: booking.shop,
//             bookingDate: booking.bookingDate,
//             bookingTime: booking.bookingTime,
//             createdAt: booking.createdAt,
//             status: BookingStatus.cancelled,
//             notes: booking.notes,
//             cancellationReason: reason,
//           );
//           _mockBookings[index] = updatedBooking;
//         } else {
//           throw Exception('Booking cannot be cancelled');
//         }
//       } else {
//         throw Exception('Booking not found');
//       }
//     } catch (e) {
//       throw Exception('Failed to cancel booking: $e');
//     }
//   }

//   @override
//   Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
//     try {
//       // Simulate API call delay
//       await Future.delayed(const Duration(seconds: 1));
      
//       // TODO: Replace with actual API call
//       // await _apiService.updateBookingStatus(bookingId, newStatus);
      
//       // For now, update mock storage
//       final index = _mockBookings.indexWhere((booking) => booking.id == bookingId);
//       if (index != -1) {
//         final booking = _mockBookings[index];
//         final updatedBooking = Booking(
//           id: booking.id,
//           service: booking.service,
//           shop: booking.shop,
//           bookingDate: booking.bookingDate,
//           bookingTime: booking.bookingTime,
//           createdAt: booking.createdAt,
//           status: newStatus,
//           notes: booking.notes,
//           cancellationReason: booking.cancellationReason,
//         );
//         _mockBookings[index] = updatedBooking;
//       } else {
//         throw Exception('Booking not found');
//       }
//     } catch (e) {
//       throw Exception('Failed to update booking status: $e');
//     }
//   }

//   @override
//   Future<List<Booking>> refreshBookings() async {
//     try {
//       // Simulate API call delay
//       await Future.delayed(const Duration(seconds: 1));
      
//       // TODO: Replace with actual API call
//       // return await _apiService.refreshBookings();
      
//       // For now, return sorted mock data
//       _mockBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//       return List.from(_mockBookings);
//     } catch (e) {
//       throw Exception('Failed to refresh bookings: $e');
//     }
//   }
// }