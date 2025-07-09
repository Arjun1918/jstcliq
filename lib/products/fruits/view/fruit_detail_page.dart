import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/products/fruits/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:kods/utils/theme.dart';

class FruitDetailsScreen extends StatelessWidget {
  final String fruitName;

  const FruitDetailsScreen({super.key, required this.fruitName});

  Map<String, Map<String, dynamic>> get fruitData => {
    'mango': {
      'title': 'Alphonso Mango - India Premium',
      'imagePath': 'assets/images/mango.jpg',
      'weight': '1 piece (200-300)g',
      'price': '₹ 85',
      'mrp': '₹100',
      'displayName': 'Mango',
    },
    'apple': {
      'title': 'Red Delicious Apple - Italy (Sebu)',
      'imagePath': 'assets/images/apple.jpg',
      'weight': '2 pieces (300-400)g',
      'price': '₹ 120',
      'mrp': '₹140',
      'displayName': 'Apple',
    },
    'orange': {
      'title': 'Valencia Orange - Fresh & Juicy',
      'imagePath': 'assets/images/orange.jpg',
      'weight': '3 pieces (400-500)g',
      'price': '₹ 60',
      'mrp': '₹75',
      'displayName': 'Orange',
    },
    'watermelon': {
      'title': 'Sweet Watermelon - Farm Fresh',
      'imagePath': 'assets/images/watermelon.jpg',
      'weight': '1 piece (1-1.5)kg',
      'price': '₹ 45',
      'mrp': '₹55',
      'displayName': 'Watermelon',
    },
    'muskmelon': {
      'title': 'Musk Melon - Sweet & Aromatic',
      'imagePath': 'assets/images/muskmelon.jpg',
      'weight': '1 piece (800g-1)kg',
      'price': '₹ 70',
      'mrp': '₹85',
      'displayName': 'Musk Melon',
    },
    'blueberry': {
      'title': 'Fresh Blueberries - Premium Quality',
      'imagePath': 'assets/images/blueberry.jpg',
      'weight': '100g pack',
      'price': '₹ 180',
      'mrp': '₹200',
      'displayName': 'Blueberry',
    },
  };

  Map<String, dynamic> get currentFruit =>
      fruitData[fruitName] ?? fruitData['apple']!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => context.pop(),
        ),
        title: Center(
          child: Text(
            currentFruit['displayName'],
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                onPressed: () {
                  context.push('/cart');
                },
              ),
              // Cart badge
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.totalItems > 0) {
                    return Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.h,
                        ),
                        child: Text(
                          '${cartProvider.totalItems}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  currentFruit['imagePath'],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                "Season's Best",
                style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
              ),
            ),

            SizedBox(height: 8.h),
            Text(
              currentFruit['title'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),

            SizedBox(height: 16.h),

            // Price Section
            Text(
              currentFruit['weight'],
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 8.h),

            Row(
              children: [
                Text(
                  currentFruit['price'],
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'MRP ${currentFruit['mrp']}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Simplified Quantity Section
            _QuantitySelector(fruitName: fruitName, currentFruit: currentFruit),

            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note: ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Any given time only one cart item can have products from one shop',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            
            // Show View Cart button only if cart has items
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                if (cartProvider.totalItems > 0) {
                  return SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        context.push('/cart');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'View Cart (${cartProvider.totalItems} items)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final String fruitName;
  final Map<String, dynamic> currentFruit;

  const _QuantitySelector({
    required this.fruitName,
    required this.currentFruit,
  });

  void _showAddedToCartMessage(BuildContext context, String displayName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$displayName added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  void _showRemovedFromCartMessage(BuildContext context, String displayName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$displayName removed from cart'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final currentQuantity = cartProvider.getItemQuantity(fruitName);

        // If item is not in cart, show ADD TO CART button
        if (currentQuantity == 0) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add item to cart with quantity 1
                final cartItem = CartItem(
                  fruitName: fruitName,
                  title: currentFruit['title'],
                  imagePath: currentFruit['imagePath'],
                  weight: currentFruit['weight'],
                  price: currentFruit['price'],
                  mrp: currentFruit['mrp'],
                  displayName: currentFruit['displayName'],
                  quantity: 1,
                );
                cartProvider.addItem(cartItem);
                _showAddedToCartMessage(context, currentFruit['displayName']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'ADD TO CART',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }

        // If item is in cart, show quantity selector
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8.r),
            color: AppTheme.primaryColor.withOpacity(0.05),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Decrease button
              IconButton(
                onPressed: () {
                  if (currentQuantity == 1) {
                    // Remove item completely if quantity becomes 0
                    cartProvider.removeItem(fruitName);
                    _showRemovedFromCartMessage(context, currentFruit['displayName']);
                  } else {
                    // Just decrease quantity
                    cartProvider.updateQuantity(fruitName, currentQuantity - 1);
                  }
                },
                icon: Icon(
                  Icons.remove,
                  size: 22.sp,
                  color: AppTheme.primaryColor,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  padding: EdgeInsets.all(8.w),
                ),
              ),
              
              // Quantity display with item name
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentQuantity.toString(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        'in cart',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTheme.primaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Increase button
              IconButton(
                onPressed: () {
                  cartProvider.updateQuantity(fruitName, currentQuantity + 1);
                },
                icon: Icon(
                  Icons.add,
                  size: 22.sp,
                  color: AppTheme.primaryColor,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  padding: EdgeInsets.all(8.w),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}