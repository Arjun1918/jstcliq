import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final double size;

  const NotificationBell({
    super.key,
    this.onTap,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: Icon(
        Icons.notifications,
        color: color ?? theme.textTheme.bodyLarge?.color,
        size: size,
      ),
      onPressed: onTap ?? () {},
      tooltip: 'Notifications',
    );
  }
}
