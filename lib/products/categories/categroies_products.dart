import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/menu_drawer/menu_drawer.dart';
import 'package:kods/common/widgets/notification_bell.dart';
import 'package:kods/common/widgets/shimmer.dart';
import 'package:kods/utils/theme.dart';

class ProductExploreScreen extends StatefulWidget {
  const ProductExploreScreen({super.key});

  @override
  State<ProductExploreScreen> createState() => _ProductExploreScreenState();
}

class _ProductExploreScreenState extends State<ProductExploreScreen> {
  bool _isLoading = true;

  final List<Map<String, dynamic>> productCategories = [
    {
      'title': 'Fruits',
      'imagePath': 'assets/images/fruits.png',
      'route': '/fruitshop',
    },
    {
      'title': 'Vegetables',
      'imagePath': 'assets/images/vegetables.png',
      'route': '/vegetables',
    },
    {
      'title': 'Chocolates',
      'imagePath': 'assets/images/chocolates.png',
      'route': '/chocolates',
    },
    {
      'title': 'Dairy',
      'imagePath': 'assets/images/dairy.png',
      'route': '/dairy',
    },
    {
      'title': 'Electronics',
      'imagePath': 'assets/images/electronics.png',
      'route': '/electronics',
    },
    {
      'title': 'Others',
      'imagePath': 'assets/images/others.png',
      'route': '/others',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
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
            'Explore Products',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [NotificationBell(onTap: () {})],
      ),
      drawer: const MenuDrawer(),
      body: _isLoading ? const ProductExploreShimmerLoading() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: 24.h),
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.3,
            children: productCategories.map((category) {
              return _buildCategoryCard(
                title: category['title'],
                imagePath: category['imagePath'],
                onTap: () => context.push(category['route']),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Products',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7, // 70% of the space for image
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        alignment: Alignment.center,
                        child: Icon(
                          _getIconForCategory(title),
                          size: 40.sp,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3, // 30% of the space for title
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String title) {
    switch (title.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'chocolates':
        return Icons.cake;
      case 'dairy':
        return Icons.local_drink;
      case 'electronics':
        return Icons.devices;
      default:
        return Icons.more_horiz;
    }
  }
}

// Product Explore specific shimmer loading
class ProductExploreShimmerLoading extends StatelessWidget {
  const ProductExploreShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar shimmer
          ShimmerLoading(
            height: 48.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(height: 24.h),

          // Categories title shimmer
          ShimmerLoading(
            width: 100.w,
            height: 20.h,
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
          ),
          SizedBox(height: 16.h),

          // Categories grid shimmer
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.3,
            children: List.generate(
              6,
              (index) => _buildCategoryShimmerCard(),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildCategoryShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: ShimmerLoading(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Center(
                child: ShimmerLoading(
                  width: 80.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}