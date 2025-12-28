import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../main.dart';

/// Service for handling push notifications via OneSignal
class NotificationService {
  static const String _appId = String.fromEnvironment(
    'ONESIGNAL_APP_ID',
    defaultValue: 'YOUR_ONESIGNAL_APP_ID',
  );

  /// Initialize OneSignal
  Future<void> initialize() async {
    OneSignal.initialize(_appId);

    // Request permission
    await OneSignal.Notifications.requestPermission(true);

    // Set up notification handlers
    OneSignal.Notifications.addClickListener((event) {
      _handleNotificationClick(event);
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // Customize foreground notification display
      event.notification.display();
    });
  }

  void _handleNotificationClick(OSNotificationClickEvent event) {
    final data = event.notification.additionalData;
    if (data == null) return;

    final type = data['type'] as String?;
    final payload = data['payload'] as Map<String, dynamic>?;

    // Handle different notification types
    switch (type) {
      case 'workout_reminder':
        // Navigate to today's workout
        break;
      case 'streak_at_risk':
        // Navigate to home
        break;
      case 'coach_update':
        // Navigate to tribe
        break;
      case 'community_activity':
        // Navigate to specific post
        break;
    }
  }

  /// Set user ID for targeting
  Future<void> setUserId(String userId) async {
    await OneSignal.login(userId);
  }

  /// Log out user
  Future<void> logout() async {
    await OneSignal.logout();
  }

  /// Set user tags for segmentation
  Future<void> setUserTags(Map<String, String> tags) async {
    await OneSignal.User.addTags(tags);
  }

  /// Update workout schedule tags
  Future<void> updateScheduleTags({
    required List<String> scheduledDays,
    required String reminderTime,
  }) async {
    await setUserTags({
      'scheduled_days': scheduledDays.join(','),
      'reminder_time': reminderTime,
    });
  }

  /// Update streak tag
  Future<void> updateStreakTag(int streak) async {
    await setUserTags({
      'current_streak': streak.toString(),
    });
  }

  /// Update subscription status tag
  Future<void> updateSubscriptionTag(bool isPremium) async {
    await setUserTags({
      'is_premium': isPremium.toString(),
    });
  }

  /// Schedule a local notification
  Future<void> scheduleWorkoutReminder({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // OneSignal handles scheduling through dashboard
    // For local notifications, use flutter_local_notifications
  }

  /// Check notification permission status
  Future<bool> hasPermission() async {
    return OneSignal.Notifications.permission;
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    return await OneSignal.Notifications.requestPermission(true);
  }

  /// Enable/disable notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    if (enabled) {
      await OneSignal.User.pushSubscription.optIn();
    } else {
      await OneSignal.User.pushSubscription.optOut();
    }
  }

  /// Send in-app notification (stored in database)
  Future<void> createInAppNotification({
    required String userId,
    required String type,
    required String title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    await supabase.from('notifications').insert({
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
    });
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Get unread notifications
  Future<List<Map<String, dynamic>>> getUnreadNotifications(
    String userId,
  ) async {
    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('is_read', false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Provider for unread notifications count
final unreadNotificationsProvider = FutureProvider<int>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return 0;

  final service = ref.watch(notificationServiceProvider);
  final notifications = await service.getUnreadNotifications(userId);
  return notifications.length;
});

