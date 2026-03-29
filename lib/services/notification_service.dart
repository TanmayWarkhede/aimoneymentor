import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  static Future<void> showSIPReminder({
    required String fundName,
    required double amount,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sip_reminders',
      'SIP Reminders',
      channelDescription: 'Monthly SIP investment reminders',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF00A651),
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0,
      '💚 SIP Due Today!',
      '₹${amount.toStringAsFixed(0)} SIP for $fundName is due today',
      details,
    );
  }

  static Future<void> showMarketAlert({
    required String message,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'market_alerts',
      'Market Alerts',
      channelDescription: 'Market movement alerts',
      importance: Importance.defaultImportance,
    );

    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      1,
      '📊 Market Update',
      message,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}

