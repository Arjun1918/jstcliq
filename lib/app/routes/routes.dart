import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/app/routes/routes_name.dart';
import 'package:kods/menu_drawer/booking/view/my_booking.dart';
import 'package:kods/products/fruits/view/cart_screen.dart';
import 'package:kods/products/fruits/view/fruit_detail_page.dart';
import 'package:kods/products/fruits/view/fruit_page.dart';
import 'package:kods/products/fruits/view/fruits_shop.dart';
import 'package:kods/services/modules/categories/book_service.dart';
import 'package:kods/products/categories/categroies_products.dart';
import 'package:kods/services/modules/electrician/model/electrician_model.dart';
import 'package:kods/services/modules/electrician/view/booking_detail_screen.dart';
import 'package:kods/dashboard/view/dashboard_screen.dart';
import 'package:kods/services/modules/electrician/view/electrician_services_screen.dart';
import 'package:kods/login/view/login_screen.dart';
import 'package:kods/login/view/register_screen.dart';
import 'package:kods/utils/splash_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: RouteNames.mybooking,
        name: RouteNames.mybooking,
        builder: (BuildContext context, GoRouterState state) {
          return const MyBookingsScreen();
        },
      ),

      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: RouteNames.bookservice,
        name: RouteNames.bookservice,
        builder: (BuildContext context, GoRouterState state) {
          return const ServiceBookingScreen();
        },
      ),
      GoRoute(
        path: RouteNames.fruitspage,
        name: RouteNames.fruitspage,
        builder: (BuildContext context, GoRouterState state) {
          return const FruitsScreen();
        },
      ),

      // Add this new route for fruit details
      GoRoute(
        path: '${RouteNames.fruitDetails}/:fruitId',
        name: RouteNames.fruitDetails,
        builder: (BuildContext context, GoRouterState state) {
          final fruitId = state.pathParameters['fruitId']!;
          return FruitDetailsScreen(fruitName: fruitId);
        },
      ),

      GoRoute(
        path: RouteNames.productexplore,
        name: RouteNames.productexplore,
        builder: (BuildContext context, GoRouterState state) {
          return const ProductExploreScreen();
        },
      ),
      GoRoute(
        path: RouteNames.electricservice,
        name: RouteNames.electricservice,
        builder: (BuildContext context, GoRouterState state) {
          return const ElectricalServicesScreen();
        },
      ),
      GoRoute(
        path: RouteNames.fruitshop,
        name: RouteNames.fruitshop,
        builder: (BuildContext context, GoRouterState state) {
          return const FruitsShopScreen();
        },
      ),
      GoRoute(
        path: RouteNames.dashboard,
        name: RouteNames.dashboard,
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: RouteNames.cart,
        name: RouteNames.cart,
        builder: (BuildContext context, GoRouterState state) {
          return const CartScreen();
        },
      ),
      GoRoute(
        path: RouteNames.bookingdetail,
        name: RouteNames.bookingdetail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookingDetailsScreen(
            service: extra['service'] as ElectricalService,
            shop: extra['shop'] as ElectricalShop?,
          );
        },
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
  );
}
