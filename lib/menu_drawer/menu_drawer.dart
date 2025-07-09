import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Drawer(
        width: 240,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 60, width: 200),
                  const SizedBox(width: 8),
                ],
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.home_outlined,
                title: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/dashboard');
                  FocusScope.of(context).unfocus();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation to profile page
                  // context.push('/profile');
                  FocusScope.of(context).unfocus();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.local_offer_outlined,
                title: 'Subscription',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation to subscription page
                  // context.push('/subscription');
                  FocusScope.of(context).unfocus();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.bookmarks_outlined,
                title: 'My Bookings',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/my-bookings');
                  FocusScope.of(context).unfocus();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.shopping_cart_outlined,
                title: 'Shopping Cart',
                onTap: () {
                  Navigator.pop(context);
                  // context.push('/shopping-cart');
                  FocusScope.of(context).unfocus();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.history,
                title: 'Order History',
                onTap: () {
                  Navigator.pop(context);
                  // context.push('/order-history');
                  FocusScope.of(context).unfocus();
                },
              ),

              const Spacer(),

              Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add logout functionality
                    // context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.textTheme.bodyMedium?.color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
    );
  }
}