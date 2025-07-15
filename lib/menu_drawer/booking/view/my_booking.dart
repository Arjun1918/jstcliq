import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/common/widgets/notification_bell.dart';
import 'package:kods/menu_drawer/booking/model/booking_model.dart';
import 'package:kods/menu_drawer/booking/provider/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:kods/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to handle phone call
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Show error message if can't launch
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone dialer'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _showCancelDialog(Booking booking) {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Cancel Booking',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to cancel this booking?',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              FormBuilderTextField(
                name: 'reason',
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Reason for cancellation (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Keep Booking', style: TextStyle(fontSize: 14.sp)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.saveAndValidate() ?? false) {
                final reason =
                    formKey.currentState?.fields['reason']?.value ?? '';
                Navigator.of(context).pop();
                Provider.of<BookingProvider>(
                  context,
                  listen: false,
                ).cancelBooking(booking.id, reason);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Cancel Booking',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => context.pop(),
        ),
        title: Center(
          child: Text(
            'My Bookings',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: NotificationBell(onTap: () {}),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.w, color:  AppTheme.errorColor),
                  SizedBox(height: 16.h),
                  Text(
                    provider.error!,
                    style: TextStyle(fontSize: 16.sp, color:  AppTheme.errorColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => provider.loadBookings(),
                    child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(provider.upcomingBookings, isUpcoming: true),
              _buildBookingsList(provider.pastBookings, isUpcoming: false),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          final isUpcomingTab = _tabController.index == 0;
          final bookingsList = isUpcomingTab
              ? provider.upcomingBookings
              : provider.pastBookings;

          if (bookingsList.isEmpty) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/bookservice');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Book Services',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildBookingsList(
    List<Booking> bookings, {
    required bool isUpcoming,
  }) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today : Icons.history,
              size: 64.w,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isUpcoming
                  ? 'Book a service to see it here'
                  : 'Your completed bookings will appear here',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<BookingProvider>(context, listen: false).loadBookings(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: isUpcoming ? bookings.length + 1 : bookings.length,
        itemBuilder: (context, index) {
          if (isUpcoming && index == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                'Thanks for the booking!',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.sucessColor,
                ),
              ),
            );
          }

          final booking = bookings[isUpcoming ? index - 1 : index];
          return _buildBookingCard(booking, isUpcoming: isUpcoming);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, {required bool isUpcoming}) {
    String phoneNumber = (booking.shop?.phoneNumber as String?) ?? '+91 9876543210';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status and booking ID
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: booking.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  booking.statusText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: booking.statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Booking #${booking.id}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Main content with circular avatar
          Row(
            children: [
              // Circular avatar with electric icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/electric.png',
                    width: 30.w,
                    height: 30.w,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Service details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provider Name:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      booking.service.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color:AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Text(
                      'Price:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      booking.service.formattedCost,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Text(
                      'Date Required',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${booking.formattedBookingDate}  ${booking.formattedBookingTime}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Phone number section with call functionality
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () => _makePhoneCall(phoneNumber),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 18.w,
                    color:AppTheme.secondaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.w,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Shop location (if available)
          if (booking.shop != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.store, size: 16.w, color: Colors.grey[600]),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${booking.shop!.name} • ${booking.shop!.location}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
          if (booking.status == BookingStatus.cancelled &&
              booking.cancellationReason != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color:  AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16.w, color:  AppTheme.errorColor),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Cancellation reason: ${booking.cancellationReason}',
                      style: TextStyle(fontSize: 12.sp, color:  AppTheme.errorColor),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (isUpcoming && booking.canBeCancelled) ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCancelDialog(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}