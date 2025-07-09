import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/app/routes/routes_name.dart';
import 'package:kods/menu_drawer/menu_drawer.dart';
import 'package:kods/utils/theme.dart';

class FruitsScreen extends StatelessWidget {
  const FruitsScreen({super.key});

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
            'Fruits',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),

      drawer: const MenuDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 24.h),
            Text(
              'Fresh Fruits',
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
              childAspectRatio: 0.9,
              children: const [
                FruitCard(
                  title: 'Mango',
                  imagePath: 'assets/images/mango.jpg',
                  fruitId: 'mango',
                ),
                FruitCard(
                  title: 'Apple',
                  imagePath: 'assets/images/apple.jpg',
                  fruitId: 'apple',
                ),
                FruitCard(
                  title: 'Orange',
                  imagePath: 'assets/images/orange.jpg',
                  fruitId: 'orange',
                ),
                FruitCard(
                  title: 'Watermelon',
                  imagePath: 'assets/images/watermelon.jpg',
                  fruitId: 'watermelon',
                ),
                FruitCard(
                  title: 'Musk Melon',
                  imagePath: 'assets/images/muskmelon.jpg',
                  fruitId: 'muskmelon',
                ),
                FruitCard(
                  title: 'Blueberry',
                  imagePath: 'assets/images/blueberry.jpg',
                  fruitId: 'blueberry',
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Fruits',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FruitCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String fruitId;

  const FruitCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.fruitId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 70.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 32.h,
            child: ElevatedButton(
              onPressed: () =>
                  context.push('${RouteNames.fruitDetails}/$fruitId'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                minimumSize: Size(double.infinity, 32.h),
              ),
              child: Text('View Details', style: TextStyle(fontSize: 12.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
