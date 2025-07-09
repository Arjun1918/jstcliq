import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kods/utils/theme.dart';
import 'package:kods/services/modules/electrician/model/electrician_model.dart';
import 'package:kods/services/modules/electrician/provider/electrical_provider.dart';

class ElectricalServicesScreen extends StatefulWidget {
  final ElectricalShop? shop;

  const ElectricalServicesScreen({super.key, this.shop});

  @override
  State<ElectricalServicesScreen> createState() =>
      _ElectricalServicesScreenState();
}

class _ElectricalServicesScreenState extends State<ElectricalServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ElectricalProvider>();
      if (widget.shop != null) {
        provider.loadServicesForShop(widget.shop!.id);
      } else {
        provider.loadAllElectricalServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shop = widget.shop;

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
          shop?.name ?? 'Electrical Services',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: Consumer<ElectricalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading services...',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.w, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      provider.error!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearError();
                        if (shop != null) {
                          provider.loadServicesForShop(shop.id);
                        } else {
                          provider.loadAllElectricalServices();
                        }
                      },
                      child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),
              ),
            );
          }

          // Get services from either the shop or the provider
          final services = shop?.services ?? provider.services;

          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.electrical_services_outlined,
                    size: 64.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No services available',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please try again later',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (shop != null) ...[
                  _buildShopInfo(shop),
                  SizedBox(height: 20.h),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Services',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '${services.length} services',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(),
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: _getChildAspectRatio(),
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return _buildServiceCard(context, service, shop);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _getCrossAxisCount() {
    // Responsive grid based on screen width
    if (1.sw < 600) {
      return 2; // Mobile: 2 columns
    } else if (1.sw < 900) {
      return 3; // Tablet: 3 columns
    } else {
      return 4; // Desktop: 4 columns
    }
  }

  double _getChildAspectRatio() {
    // Adjust aspect ratio based on screen size
    if (1.sw < 600) {
      return 0.8; // Mobile
    } else if (1.sw < 900) {
      return 0.85; // Tablet
    } else {
      return 0.9; // Desktop
    }
  }

  Widget _buildShopInfo(ElectricalShop shop) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
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
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    shop.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.electrical_services,
                        color: AppTheme.primaryColor,
                        size: 30.w,
                      );
                    },
                  ),
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
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      shop.distance,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            shop.details,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 16.w, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  shop.timings,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.location_on, size: 16.w, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  shop.location,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    ElectricalService service,
    ElectricalShop? shop,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: service.isAvailable
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: service.isAvailable
                          ? AppTheme.secondaryColor.withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Icon(
                      _getServiceIcon(service.name),
                      size: 24.w,
                      color: service.isAvailable
                          ? AppTheme.primaryColor
                          : Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    service.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: service.isAvailable
                          ? Colors.grey[800]
                          : Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    service.formattedCost,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: service.isAvailable
                          ? AppTheme.primaryColor
                          : Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 32.h,
              child: GestureDetector(
                onTap: service.isAvailable
                    ? () => _onBookService(service, shop)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: service.isAvailable
                        ? AppTheme.primaryColor
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      service.isAvailable ? 'Book Now' : 'Unavailable',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'general service':
        return Icons.build;
      case 'emergency service':
        return Icons.emergency;
      case 'wiring & installation':
      case 'wiring & cables':
        return Icons.cable;
      case 'appliance repair':
        return Icons.home_repair_service;
      case 'smart home setup':
        return Icons.smartphone;
      case 'panel upgrade':
        return Icons.electrical_services;
      case 'lighting solutions':
        return Icons.lightbulb;
      case 'safety inspection':
        return Icons.security;
      case 'solar installation':
        return Icons.solar_power;
      case 'generator service':
        return Icons.power;
      case 'electrical consultancy':
        return Icons.engineering;
      case 'installation service':
        return Icons.construction;
      default:
        return Icons.electrical_services;
    }
  }

  void _onBookService(ElectricalService service, ElectricalShop? shop) {
    context.push('/booking-details', extra: {'service': service, 'shop': shop});
  }
}
