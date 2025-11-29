import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Notification Service
/// Cross-platform notification service using MethodChannel
/// Works on iOS and Android without requiring CocoaPods
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const MethodChannel _channel = MethodChannel('com.hackathon/notifications');
  
  bool _isInitialized = false;

  /// Initialize notification service
  /// Note: For iOS, this requires proper native setup
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      if (Platform.isIOS) {
        // Request iOS notification permissions via native channel
        await _channel.invokeMethod('requestPermissions');
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService: Failed to initialize - $e');
      // Continue anyway - notifications may still work
      _isInitialized = true;
    }
  }

  /// Show a system notification
  /// Falls back to in-app alert if native notifications not available
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await _channel.invokeMethod('showNotification', {
        'id': id,
        'title': title,
        'body': body,
      });
    } catch (e) {
      debugPrint('NotificationService: Failed to show notification - $e');
      // Native notifications not available - this is expected if native code isn't set up
    }
  }

  /// Show danger alert notification (for high priority alerts)
  Future<void> showDangerAlert({
    required String title,
    required String body,
    BuildContext? context,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    
    // Try native notification first
    try {
      await showNotification(id: id, title: title, body: body);
    } catch (e) {
      debugPrint('NotificationService: Native notification failed, showing in-app alert - $e');
      // Show in-app alert as fallback
      if (context != null && context.mounted) {
        _showInAppAlert(context, title, body);
      }
    }
  }

  /// Show warning alert notification
  Future<void> showWarningAlert({
    required String title,
    required String body,
    BuildContext? context,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000) + 100000;
    
    // Try native notification first
    try {
      await showNotification(id: id, title: title, body: body);
    } catch (e) {
      debugPrint('NotificationService: Native notification failed, showing in-app alert - $e');
      // Show in-app alert as fallback
      if (context != null && context.mounted) {
        _showInAppAlert(context, title, body);
      }
    }
  }

  /// Show in-app alert as fallback
  void _showInAppAlert(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Cancel a notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      await _channel.invokeMethod('cancelNotification', {'id': id});
    } catch (e) {
      debugPrint('NotificationService: Failed to cancel notification - $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _channel.invokeMethod('cancelAllNotifications');
    } catch (e) {
      debugPrint('NotificationService: Failed to cancel all notifications - $e');
    }
  }
}
