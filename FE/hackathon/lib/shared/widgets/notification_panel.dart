import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'notification_item.dart';

/// Notification Panel Widget
/// Slide-down panel displaying notifications
class NotificationPanel extends StatelessWidget {
  final bool isVisible;
  final VoidCallback? onClose;
  final List<NotificationItemData> notifications;

  const NotificationPanel({
    super.key,
    this.isVisible = false,
    this.onClose,
    this.notifications = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 431,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Drag Handle
            GestureDetector(
              onTap: onClose,
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF99A1AF),
                  borderRadius: BorderRadius.circular(16777200),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF364153),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Notification List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationItem(
                    iconGradient: notification.iconGradient,
                    icon: notification.icon,
                    title: notification.title,
                    timeAgo: notification.timeAgo,
                    description: notification.description,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Notification Item Data Model
class NotificationItemData {
  final LinearGradient iconGradient;
  final IconData icon;
  final String title;
  final String timeAgo;
  final String description;

  const NotificationItemData({
    required this.iconGradient,
    required this.icon,
    required this.title,
    required this.timeAgo,
    required this.description,
  });
}

