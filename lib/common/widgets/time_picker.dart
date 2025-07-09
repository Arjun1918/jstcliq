import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kods/common/provider/time_picker_provider.dart';
import 'package:provider/provider.dart';

class CustomTimePicker extends StatelessWidget {
  final Function(TimeOfDay selectedTime) onTimeSelected;

  const CustomTimePicker({super.key, required this.onTimeSelected});

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      Provider.of<TimePickerProvider>(context, listen: false).updateSelectedTime(picked);
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTime = context.watch<TimePickerProvider>().selectedTime;

    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Time', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, size: 20.w, color: Colors.grey),
                SizedBox(width: 12.w),
                Text(
                  selectedTime != null
                      ? selectedTime.format(context)
                      : 'Tap to select time',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedTime != null ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
