import 'package:flutter/material.dart';

// Custom Snackbar Types
enum SnackbarType { success, error, warning, info }

// Custom Snackbar Widget
class CustomSnackbar extends StatelessWidget {
  final String message;
  final SnackbarType type;
  final Duration duration;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const CustomSnackbar({
    Key? key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.onActionPressed,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onActionPressed,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  color: _getActionColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF4CAF50).withOpacity(0.1);
      case SnackbarType.error:
        return const Color(0xFFF44336).withOpacity(0.1);
      case SnackbarType.warning:
        return const Color(0xFFFF9800).withOpacity(0.1);
      case SnackbarType.info:
        return const Color(0xFF2196F3).withOpacity(0.1);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF4CAF50);
      case SnackbarType.error:
        return const Color(0xFFF44336);
      case SnackbarType.warning:
        return const Color(0xFFFF9800);
      case SnackbarType.info:
        return const Color(0xFF2196F3);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF2E7D32);
      case SnackbarType.error:
        return const Color(0xFFD32F2F);
      case SnackbarType.warning:
        return const Color(0xFFE65100);
      case SnackbarType.info:
        return const Color(0xFF1976D2);
    }
  }

  Color _getActionColor() {
    return _getIconColor();
  }

  IconData _getIcon() {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.error:
        return Icons.error;
      case SnackbarType.warning:
        return Icons.warning;
      case SnackbarType.info:
        return Icons.info;
    }
  }
}

// Helper class for showing snackbars
class SnackbarHelper {
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showCustomSnackbar(
      context,
      message,
      SnackbarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showCustomSnackbar(
      context,
      message,
      SnackbarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showCustomSnackbar(
      context,
      message,
      SnackbarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showCustomSnackbar(
      context,
      message,
      SnackbarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void _showCustomSnackbar(
    BuildContext context,
    String message,
    SnackbarType type, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final snackbar = SnackBar(
      content: CustomSnackbar(
        message: message,
        type: type,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

// Extension for easier usage
extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.showSuccess(this, message, duration: duration ?? const Duration(seconds: 3));
  }

  void showErrorSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.showError(this, message, duration: duration ?? const Duration(seconds: 4));
  }

  void showWarningSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.showWarning(this, message, duration: duration ?? const Duration(seconds: 3));
  }

  void showInfoSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.showInfo(this, message, duration: duration ?? const Duration(seconds: 3));
  }
}

