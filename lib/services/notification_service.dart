import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Bildirim servisi - Hatırlatmalar ve uyarılar
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
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

    await _notifications.initialize(settings);
  }

  Future<void> requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Günlük hatırlatma bildirimi
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    // TODO: Implement scheduled notifications
  }

  /// Anlık bildirim göster
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'dopamin_yonet_channel',
      'Dopamin Yönet',
      channelDescription: 'Dopamin Yönet bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Motivasyon bildirimi
  Future<void> showMotivationalNotification() async {
    const messages = [
      ('💪 Bugün harika gidiyorsun!', 'Her küçük adım önemli.'),
      ('🎯 Odaklan!', 'Hedefine yaklaşıyorsun.'),
      ('🌱 Ağacın büyüyor!', 'Tutarlılığın meyvesini veriyor.'),
      ('⚡ Enerjin yükseliyor!', 'Dopamin dengen iyileşiyor.'),
    ];

    final random = DateTime.now().second % messages.length;
    final message = messages[random];

    await showNotification(title: message.$1, body: message.$2);
  }

  /// İstek anı hatırlatması
  Future<void> showUrgeReminderNotification() async {
    await showNotification(
      title: '⚡ İstek anı mı?',
      body: 'Nefes al, bu his geçici. Uygulamayı aç, yardım burada.',
    );
  }

  /// Tüm bildirimleri iptal et
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
