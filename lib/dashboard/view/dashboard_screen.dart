import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/common/widgets/shimmer.dart';
import 'package:kods/dashboard/provider/dashboard_provider.dart';
import 'package:kods/utils/theme.dart';
import 'package:kods/menu_drawer/menu_drawer.dart';
import 'package:kods/common/widgets/notification_bell.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> featuredServices = const [
    {'name': 'AC Repair', 'icon': Icons.ac_unit},
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Electrical', 'icon': Icons.electrical_services},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Painting', 'icon': Icons.format_paint},
  ];

  final List<Map<String, dynamic>> featuredProducts = const [
    {'name': 'Air Filters', 'icon': Icons.air},
    {'name': 'LED Bulbs', 'icon': Icons.lightbulb},
    {'name': 'Tools', 'icon': Icons.build},
    {'name': 'Paints', 'icon': Icons.palette},
    {'name': 'Pipes', 'icon': Icons.water},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        automaticallyImplyLeading: false,
        leadingWidth: 52.w,
        leading: Builder(
          builder: (context) => Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: AppTheme.textPrimary, size: 22.sp),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 50.h,
            width: 120.w,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: NotificationBell(onTap: () {}),
          ),
        ],
      ),
      drawer: const MenuDrawer(),
      body: provider.isLoading
          ? const DashboardShimmerLoading()
          : _buildContent(context, theme),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          // Compact Welcome Section
          _buildWelcomeSection(theme),
          SizedBox(height: 16.h),
          // Main Action Cards
          _buildMainActionCards(context, theme),
          SizedBox(height: 20.h),
          // Featured Services
          _buildFeatureSection(theme, 'Featured Services', featuredServices),
          SizedBox(height: 16.h),
          // Featured Products
          _buildFeatureSection(theme, 'Featured Products', featuredProducts),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, AppTheme.surfaceColor.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome Back!',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Discover premium services and quality products',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 13.sp,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionCards(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        _buildActionCard(
          context,
          theme,
          title: 'Book',
          subtitle: 'Services',
          icon: Icons.home_repair_service,
          route: '/bookservice',
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.secondaryColor,
              AppTheme.secondaryColor.withOpacity(0.8),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _buildActionCard(
          context,
          theme,
          title: 'Buy',
          subtitle: 'Products',
          icon: Icons.shopping_cart,
          route: '/productexplore',
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.primaryColor,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required LinearGradient gradient,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          height: 130.h, // Increased from 120.h to give more vertical room
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () => context.push(route),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ), // reduced padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w), // reduced from 10.w
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        icon,
                        size: 24.sp, // reduced from 26.sp
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h), // reduced from 8.h
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp, // reduced from 17.sp
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp, // reduced from 14.sp
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection(ThemeData theme, String title, List<Map> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 110.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 90.w,
                margin: EdgeInsets.only(
                  left: index == 0 ? 4.w : 0,
                  right: 12.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              item['icon'],
                              size: 22.sp,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
