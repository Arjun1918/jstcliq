import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/menu_drawer/menu_drawer.dart';
import 'package:kods/common/widgets/notification_bell.dart';
import 'package:kods/common/widgets/category_card.dart';
import 'package:kods/common/widgets/shimmer.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  bool _isLoading = true;

  final List<Map<String, dynamic>> serviceCategories = [
    {
      'title': 'Electrical',
      'icon': Icons.electrical_services,
      'route': '/electricservice',
    },
    {
      'title': 'Plumbing',
      'icon': Icons.plumbing,
      'route': '/plumbing',
    },
    {
      'title': 'Computer',
      'icon': Icons.computer,
      'route': '/computer',
    },
    {
      'title': 'Etc',
      'icon': Icons.more_horiz,
      'route': '/etc',
    },
    {
      'title': 'Carpentry',
      'icon': Icons.handyman,
      'route': '/carpentry',
    },
    {
      'title': 'Mechanical',
      'icon': Icons.build,
      'route': '/mechanical',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    // Simulate API call or data loading
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.textTheme.bodyLarge?.color),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Center(
          child: Text(
            'Explore Services',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [NotificationBell(onTap: () {})],
      ),
      drawer: const MenuDrawer(),
      body: _isLoading ? const ServiceBookingShimmerLoading() : _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Services',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: serviceCategories.map((category) {
              return CategoryCard(
                title: category['title'],
                icon: category['icon'],
                onTap: () => context.push(category['route']),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Service Booking specific shimmer loading
class ServiceBookingShimmerLoading extends StatelessWidget {
  const ServiceBookingShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar shimmer
          ShimmerLoading(
            height: 48,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),

          // Categories title shimmer
          const ShimmerLoading(
            width: 100,
            height: 20,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Categories grid shimmer
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: List.generate(
              6,
              (index) => ShimmerLoading(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}