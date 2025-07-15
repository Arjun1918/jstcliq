import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kods/menu_drawer/order_status/model/order_status.dart';
import 'package:kods/menu_drawer/order_status/provider/order_status_provider.dart';
import 'package:provider/provider.dart';

class OrderStatusScreen extends StatefulWidget {
  final String orderId;

  const OrderStatusScreen({super.key, required this.orderId});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderStatusProvider>(
        context,
        listen: false,
      ).loadOrderStatus(widget.orderId);
    });
  }

  void _showCancelDialog() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Cancel Order',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this order?',
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF718096)),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reason for cancellation (optional)',
                hintStyle: TextStyle(
                  color: const Color(0xFF718096),
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xFF9AA6B2),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Keep Order',
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF718096)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<OrderStatusProvider>(
                context,
                listen: false,
              ).cancelOrder(reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text('Cancel Order', style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showError('Could not launch phone dialer');
      }
    } catch (e) {
      _showError('Error making call: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF5252),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Order Status',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<OrderStatusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9AA6B2)),
              ),
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
                    color: const Color(0xFFFF5252),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    provider.error!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFFFF5252),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => provider.loadOrderStatus(widget.orderId),
                    child: Text('Retry', style: TextStyle(fontSize: 16.sp)),
                  ),
                ],
              ),
            );
          }

          final order = provider.currentOrder;
          if (order == null) {
            return const Center(child: Text('No order found'));
          }

          return RefreshIndicator(
            onRefresh: provider.refreshOrderStatus,
            color: const Color(0xFF9AA6B2),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header
                  _buildOrderHeader(order),
                  SizedBox(height: 20.h),

                  // Status Timeline
                  _buildStatusTimeline(order),
                  SizedBox(height: 20.h),

                  // Electrician Info
                  if (order.assignedElectrician != null)
                    _buildElectricianInfo(order.assignedElectrician!),
                  SizedBox(height: 20.h),

                  // Service Details
                  _buildServiceDetails(order),
                  SizedBox(height: 20.h),

                  // Status Updates
                  _buildStatusUpdates(order),
                  SizedBox(height: 20.h),

                  // Action Buttons
                  _buildActionButtons(order),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(OrderStatus order) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  order.statusText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: order.statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Order #${order.id}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            order.serviceName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            order.formattedAmount,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9AA6B2),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.schedule, size: 16.w, color: const Color(0xFF718096)),
              SizedBox(width: 8.w),
              Text(
                '${order.formattedDate} • ${order.scheduledTime}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
          if (order.estimatedArrival != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.directions_car,
                  size: 16.w,
                  color: const Color(0xFF9AA6B2),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Estimated arrival: ${order.estimatedArrival}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF9AA6B2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(OrderStatus order) {
    final timelineData = [
      {'title': 'Order Placed', 'status': OrderStatusType.pending},
      {'title': 'Order Confirmed', 'status': OrderStatusType.confirmed},
      {'title': 'Electrician En Route', 'status': OrderStatusType.enRoute},
      {'title': 'Electrician Arrived', 'status': OrderStatusType.arrived},
      {'title': 'Work In Progress', 'status': OrderStatusType.inProgress},
      {'title': 'Work Completed', 'status': OrderStatusType.completed},
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Progress',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 16.h),
          Timeline.tileBuilder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            theme: TimelineThemeData(
              nodePosition: 0,
              connectorTheme: const ConnectorThemeData(
                thickness: 2,
                color: Color(0xFFE2E8F0),
              ),
            ),
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              itemCount: timelineData.length,
              contentsBuilder: (context, index) {
                final item = timelineData[index];
                final isCompleted =
                    order.status.index >=
                    (item['status'] as OrderStatusType).index;
                final isActive = order.status == item['status'];

                return Padding(
                  padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                  child: Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isCompleted || isActive
                          ? const Color(0xFF2D3748)
                          : const Color(0xFF718096),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
              indicatorBuilder: (context, index) {
                final item = timelineData[index];
                final isCompleted =
                    order.status.index >=
                    (item['status'] as OrderStatusType).index;
                final isActive = order.status == item['status'];

                return DotIndicator(
                  size: 20.w,
                  color: isCompleted
                      ? const Color(0xFF4CAF50)
                      : isActive
                      ? const Color(0xFF9AA6B2)
                      : const Color(0xFFE2E8F0),
                  child: isCompleted
                      ? Icon(Icons.check, size: 12.w, color: Colors.white)
                      : null,
                );
              },
              connectorBuilder: (context, index, connectorType) {
                final item = timelineData[index];
                final isCompleted =
                    order.status.index >=
                    (item['status'] as OrderStatusType).index;

                return SolidLineConnector(
                  color: isCompleted
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE2E8F0),
                  thickness: 2,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElectricianInfo(Electrician electrician) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Electrician',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              CircleAvatar(
                radius: 30.w,
                backgroundColor: const Color(0xFF9AA6B2).withOpacity(0.2),
                backgroundImage: NetworkImage(electrician.profileImage),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      electrician.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      electrician.specialization,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF718096),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.w,
                          color: const Color(0xFFFFC107),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          electrician.formattedRating,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF718096),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '${electrician.experienceYears} years exp',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makePhoneCall(electrician.phoneNumber),
                  icon: Icon(
                    Icons.phone,
                    size: 20.w,
                    color: const Color(0xFF9AA6B2),
                  ),
                  label: Text(
                    'Call Now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF9AA6B2),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF9AA6B2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to chat or messaging
                  },
                  icon: Icon(Icons.message, size: 20.w),
                  label: Text('Message', style: TextStyle(fontSize: 16.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AA6B2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
          if (electrician.currentLocation != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16.w,
                  color: const Color(0xFF9AA6B2),
                ),
                SizedBox(width: 8.w),
                Text(
                  electrician.currentLocation!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceDetails(OrderStatus order) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            icon: Icons.home_repair_service,
            title: 'Service',
            value: order.serviceName,
          ),
          _buildDetailRow(
            icon: Icons.person,
            title: 'Customer',
            value: order.customerName,
          ),
          _buildDetailRow(
            icon: Icons.location_on,
            title: 'Address',
            value: order.customerAddress,
          ),
          if (order.workDescription != null)
            _buildDetailRow(
              icon: Icons.description,
              title: 'Description',
              value: order.workDescription!,
            ),
          _buildDetailRow(
            icon: Icons.payments,
            title: 'Amount',
            value: order.formattedAmount,
            valueColor: const Color(0xFF9AA6B2),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.w, color: const Color(0xFF9AA6B2)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdates(OrderStatus order) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Updates',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 16.h),
          Timeline.tileBuilder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            theme: TimelineThemeData(
              nodePosition: 0,
              connectorTheme: const ConnectorThemeData(
                thickness: 2,
                color: Color(0xFFE2E8F0),
              ),
            ),
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              itemCount: order.statusUpdates.length,
              contentsBuilder: (context, index) {
                final update = order.statusUpdates[index];
                return Padding(
                  padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        update.message,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        update.formattedTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                );
              },
              indicatorBuilder: (context, index) {
                final update = order.statusUpdates[index];
                return DotIndicator(
                  size: 8.w,
                  color: update.status.index >= OrderStatusType.completed.index
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF9AA6B2),
                );
              },
              connectorBuilder: (context, index, connectorType) {
                return const SolidLineConnector(
                  color: Color(0xFFE2E8F0),
                  thickness: 2,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrderStatus order) {
    if (order.status == OrderStatusType.completed ||
        order.status == OrderStatusType.cancelled) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (order.status == OrderStatusType.pending ||
            order.status == OrderStatusType.confirmed)
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: OutlinedButton(
              onPressed: _showCancelDialog,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF5252)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'Cancel Order',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFFFF5252),
                ),
              ),
            ),
          ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to help/support
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9AA6B2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Need Help?',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
