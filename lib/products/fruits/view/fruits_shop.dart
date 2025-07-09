import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FruitsShopScreen extends StatelessWidget {
  const FruitsShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.textTheme.bodyLarge?.color,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'Category Name (Fruits)',
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFruitShopCard(
            context,
            shopName: 'SRI FRUIT SHOP',
            location: 'S.R.R NAGAR',
            timing: 'Timings: 9:30am - 9pm',
            cost: 'Cost: Rs.200',
            rating: 4.5,
            imagePath: 'assets/images/fruit_shop.jpg',
            shopId: 'sri_fruit_shop',
          ),
          const SizedBox(height: 16),
          _buildFruitShopCard(
            context,
            shopName: 'JAI FRUIT SHOP',
            location: 'KPHB CIRCLE',
            timing: 'Timings: 8:30am - 10pm',
            cost: 'Cost: Rs.250',
            rating: 4.2,
            imagePath: 'assets/images/fruit_shop.jpg',
            shopId: 'jai_fruit_shop',
          ),
          const SizedBox(height: 16),
          _buildFruitShopCard(
            context,
            shopName: 'A J FRUIT SHOP',
            location: 'UTTARKAHALLI',
            timing: 'Timings: 9:00am - 9pm',
            cost: 'Cost: Rs.180',
            rating: 4.7,
            imagePath: 'assets/images/fruit_shop.jpg',
            shopId: 'aj_fruit_shop',
          ),
        ],
      ),
    );
  }

  Widget _buildFruitShopCard(
    BuildContext context, {
    required String shopName,
    required String location,
    required String timing,
    required String cost,
    required double rating,
    required String imagePath,
    required String shopId,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/fruitspage');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 60,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Colors.orange[50],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Image.asset(
                          imagePath,
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 60,
                              color: Colors.orange[50],
                              child: const Icon(
                                Icons.storefront,
                                color: Colors.orange,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.blue[400]!, Colors.blue[600]!],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 2,
                              height: 15,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            Container(
                              width: 2,
                              height: 15,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            Container(
                              width: 2,
                              height: 15,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timing,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cost,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // Rating
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating.floor()
                                  ? Icons.star
                                  : (index < rating && rating % 1 != 0)
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber[600],
                              size: 14,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
