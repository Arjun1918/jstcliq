import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/common/provider/date_picker_provider.dart';
import 'package:kods/common/provider/time_picker_provider.dart';
import 'package:kods/common/widgets/date_month_utils.dart';
import 'package:kods/common/widgets/snackbar.dart';
import 'package:kods/menu_drawer/booking/provider/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:kods/common/widgets/date_picker.dart';
import 'package:kods/common/widgets/time_picker.dart';
import 'package:kods/utils/theme.dart';
import 'package:kods/services_screens/modules/electrician/model/electrician_model.dart';
import 'package:kods/services_screens/modules/electrician/provider/electrical_provider.dart';

class BookingDetailsScreen extends StatefulWidget {
  final ElectricalService service;
  final ElectricalShop? shop;

  const BookingDetailsScreen({super.key, required this.service, this.shop});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final electricalProvider = Provider.of<ElectricalProvider>(
        context,
        listen: false,
      );

      final bookingProvider = Provider.of<BookingProvider>(
        context,
        listen: false,
      );
      electricalProvider.setBookingProvider(bookingProvider);

      // Clear booking state
      electricalProvider.clearBookingState();
    });
  }

  void _confirmBooking() async {
    final electricalProvider = Provider.of<ElectricalProvider>(
      context,
      listen: false,
    );
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );

    try {
      await electricalProvider.confirmBooking(
        service: widget.service,
        shop: widget.shop,
      );

      if (!mounted) return;

      await bookingProvider.loadBookings();

      _showBookingConfirmationDialog();
    } catch (e) {
      if (!mounted) return;

      context.showErrorSnackbar('Booking failed: ${e.toString()}');
    }
  }

  void _showBookingConfirmationDialog() {
    final provider = Provider.of<ElectricalProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 40.w),
            ),
            SizedBox(height: 16.h),
            Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${widget.service.name}',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'Date: ${provider.selectedDate != null ? formatDate(provider.selectedDate!) : 'Not selected'}',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'Time: ${provider.selectedTime != null ? provider.selectedTime!.format(context) : 'Not selected'}',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'Cost: ${widget.service.formattedCost}',
              style: TextStyle(fontSize: 14.sp),
            ),
            if (widget.shop != null) ...[
              SizedBox(height: 4.h),
              Text(
                'Shop: ${widget.shop!.name}',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20.w),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Your booking has been saved to "My Bookings". You can view and manage it anytime.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to My Bookings screen
                    context.push('/my-bookings');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'View Bookings',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
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
        title: Text(
          'Book Service',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<ElectricalProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceDetailsCard(),
                if (widget.shop != null) ...[
                  SizedBox(height: 20.h),
                  _buildShopDetailsCard(),
                ],
                SizedBox(height: 20.h),
                ChangeNotifierProvider(
                  create: (_) => DatePickerProvider(),
                  child: CustomDatePicker(
                    onDateSelected: provider.setSelectedDate,
                  ),
                ),
                SizedBox(height: 20.h),
                ChangeNotifierProvider(
                  create: (_) => TimePickerProvider(),
                  child: CustomTimePicker(
                    onTimeSelected: provider.setSelectedTime,
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: provider.canBookService ? _confirmBooking : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.canBookService
                          ? AppTheme.primaryColor
                          : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: provider.isBookingLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Confirm Booking',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    return Container(
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
      child: Row(
        children: [
          Icon(
            Icons.electrical_services,
            color: AppTheme.primaryColor,
            size: 30.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.service.formattedCost,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                if (widget.service.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    widget.service.description,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopDetailsCard() {
    final shop = widget.shop!;
    return Container(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              shop.imageUrl,
              width: 50.w,
              height: 50.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.store, color: Colors.grey[400], size: 24.w),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  shop.location,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 2.h),
                Text(
                  shop.timings,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                if (shop.distance.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    shop.distance,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
