import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _keyEnabled = 'daily_ayah_enabled';
  static const _keyHour = 'daily_ayah_hour';
  static const _keyMinute = 'daily_ayah_minute';
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;
    try {
      tz.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('Africa/Algiers'));
      } catch (_) {}

      const androidInit =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      const iosInit = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _plugin.initialize(initSettings);
      _ready = true;

      try {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } catch (_) {}
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  static Future<bool> isEnabled() async {
    try {
      final p = await SharedPreferences.getInstance();
      return p.getBool(_keyEnabled) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<int> getHour() async {
    try {
      final p = await SharedPreferences.getInstance();
      return p.getInt(_keyHour) ?? 8;
    } catch (_) {
      return 8;
    }
  }

  static Future<int> getMinute() async {
    try {
      final p = await SharedPreferences.getInstance();
      return p.getInt(_keyMinute) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<void> setTime(int hour, int minute) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_keyHour, hour);
    await p.setInt(_keyMinute, minute);
  }

  static Future<void> scheduleDaily({
    required String title,
    required String body,
    int hour = 8,
    int minute = 0,
  }) async {
    if (!_ready) {
      await init();
    }
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyEnabled, true);
    await setTime(hour, minute);

    try {
      await _plugin.cancel(100);
    } catch (_) {}

    try {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        'daily_ayah',
        'آية اليوم',
        channelDescription: 'إشعار يومي بآية من القرآن الكريم',
        importance: Importance.high,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();

      await _plugin.zonedSchedule(
        100,
        title,
        body,
        scheduled,
        const NotificationDetails(android: androidDetails, iOS: iosDetails),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Schedule error: $e');
    }
  }

  static Future<void> cancelDaily() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setBool(_keyEnabled, false);
      await _plugin.cancel(100);
    } catch (_) {}
  }
}
