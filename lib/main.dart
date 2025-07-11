import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kods/app/routes/routes.dart';
import 'package:kods/dashboard/provider/dashboard_provider.dart';
import 'package:kods/menu_drawer/booking/provider/booking_provider.dart';
import 'package:kods/menu_drawer/my_products/provider/my_products_provider.dart';
import 'package:kods/menu_drawer/my_services/provider/service_provider.dart';
import 'package:kods/products/fruits/provider/cart_provider.dart';
import 'package:kods/login/provider/auth_provider.dart';
import 'package:kods/services/modules/electrician/provider/electrical_provider.dart';
import 'package:kods/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ServicesProvider()),
            ChangeNotifierProvider(create: (_) => ElectricalProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
            ChangeNotifierProvider(create: (_) => BookingProvider()),
            ChangeNotifierProvider(create: (_) => ProductProvider()),
          ],
          child: MaterialApp.router(
            title: 'JstCliq',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRoutes.router,
          ),
        );
      },
    );
  }
}
