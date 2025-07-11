import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kods/common/widgets/notification_bell.dart';
import 'package:kods/menu_drawer/my_services/provider/service_provider.dart';
import 'package:kods/menu_drawer/my_services/view/add_service_form.dart';
import 'package:kods/menu_drawer/my_services/view/service_card.dart';
import 'package:provider/provider.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFF5F5F5),
   appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
    onPressed: () => Navigator.pop(context),
  ),
  title: Text(
    'My Services',
    style: TextStyle(
      color: Colors.black,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
    ),
  ),
  centerTitle: true,
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
),
 body: Column(
  children: [
    SizedBox(height: 12.h), // Adds space below AppBar
    Expanded(
      child: Consumer<ServicesProvider>(
        builder: (context, servicesProvider, child) {
          if (servicesProvider.services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_repair_service_outlined,
                      size: 48.sp,
                      color: Colors.blue.shade300,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'No Services Yet',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add your first service to get started',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 80.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.9,
              ),
              itemCount: servicesProvider.services.length,
              itemBuilder: (context, index) {
                final service = servicesProvider.services[index];
                return ServiceCard(service: service);
              },
            ),
          );
        },
      ),
    ),
  ],
),
    bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () => _showAddServiceDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '+ Add Services',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    showAddServiceBottomSheet(context);
  }
}
