import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kods/common/provider/date_picker_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatelessWidget {
  final Function(DateTime selectedDate) onDateSelected;

  const CustomDatePicker({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final dateProvider = Provider.of<DatePickerProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Date', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 30)),
              selectionColor: Colors.grey.shade800,
              rangeSelectionColor: Colors.transparent,
              startRangeSelectionColor: Colors.transparent,
              endRangeSelectionColor: Colors.transparent,
              todayHighlightColor: Colors.transparent,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                dateProvider.updateSelectedDate(args.value);
                onDateSelected(args.value);
              },
            ),
          ),
        ),
        if (dateProvider.selectedDate != null)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              'Selected: ${_formatDate(dateProvider.selectedDate!)}',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
