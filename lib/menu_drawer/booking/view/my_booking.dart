import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/common/widgets/notification_bell.dart';
import 'package:kods/menu_drawer/booking/model/booking_model.dart';
import 'package:kods/menu_drawer/booking/provider/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:kods/utils/theme.dart';

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

  void _showCancelDialog(Booking booking) {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Cancel Booking',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this booking?',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Keep Booking', style: TextStyle(fontSize: 14.sp)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<BookingProvider>(context, listen: false)
                  .cancelBooking(booking.id, reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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
      child: NotificationBell(
        onTap: () {
          // Handle notification tap
        },
      ),
    ),
  ],
  bottom: TabBar(
    controller: _tabController,
    indicatorColor: AppTheme.primaryColor,
    labelColor: AppTheme.primaryColor,
    unselectedLabelColor: Colors.grey,
    labelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),
    tabs: const [
      Tab(text: 'Upcoming'),
      Tab(text: 'Past'),
    ],
  ),
),
  body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    provider.error!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
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
    );
  }
Widget _buildBookingsList(List<Booking> bookings, {required bool isUpcoming}) {
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
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: () => Provider.of<BookingProvider>(context, listen: false).loadBookings(),
    child: ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: isUpcoming ? bookings.length + 1 : bookings.length,
      itemBuilder: (context, index) {
        if (isUpcoming && index == 0) {
          // 🟢 Add "Thanks for the booking" at the top
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              'Thanks for the booking!',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
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
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.electrical_services,
                color: AppTheme.primaryColor,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.service.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      booking.service.formattedCost,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16.w,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                booking.formattedBookingDate,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time,
                size: 16.w,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                booking.formattedBookingTime,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (booking.shop != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.store,
                  size: 16.w,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${booking.shop!.name} • ${booking.shop!.location}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (booking.status == BookingStatus.cancelled && booking.cancellationReason != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16.w,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Cancellation reason: ${booking.cancellationReason}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isUpcoming && booking.canBeCancelled) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showCancelDialog(booking),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
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