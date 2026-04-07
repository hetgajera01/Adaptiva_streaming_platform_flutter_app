import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Top-level handler for FCM background messages (must be a top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // When a background message is received, show a local notification.
  await NotificationService().showInstantNotification(
    title: message.notification?.title ?? 'New Notification',
    body: message.notification?.body ?? '',
    payload: json.encode(message.data),
  );
}

class NotificationService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // ── Plugin instances ───────────────────────────────────────────────────────
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// A navigator key the app should attach to [MaterialApp] so notification
  /// taps can navigate without a BuildContext.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // ── Android notification channel ───────────────────────────────────────────
  static const String _channelId = 'adaptiva_channel';
  static const String _channelName = 'Adaptiva Notifications';
  static const String _channelDescription =
      'Notifications for the Adaptiva streaming platform';

  // Stores the payload from a notification that launched the app.
  static String? _initialPayload;

  // ── Initialization ─────────────────────────────────────────────────────────

  /// Call once in [main] **after** Firebase.initializeApp().
  Future<void> initialize() async {
    // 1. Initialize timezone data (for scheduled notifications)
    tz_data.initializeTimeZones();

    // 2. Android initialisation settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. iOS initialisation settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 4. Initialize the local notification plugin
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 5. Create the Android notification channel (Android 8+)
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 6. Request notification permission (Android 13+)
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // 7. Setup Firebase Cloud Messaging
    await _setupFCM();
  }

  // ── Instant Notification ───────────────────────────────────────────────────

  /// Show an immediate local notification.
  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
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

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  // ── Scheduled Notification ─────────────────────────────────────────────────

  /// Schedule a notification at a specific time in the future.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
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

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // ── Cancel Notifications ───────────────────────────────────────────────────

  /// Cancel a single notification by its ID.
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all active notifications.
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // ── Notification Tap Handler ───────────────────────────────────────────────

  /// Called when the user taps a notification.
  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    _handlePayloadNavigation(payload);
  }

  /// Parse the payload and navigate accordingly.
  static void _handlePayloadNavigation(String payload) {
    try {
      final data = json.decode(payload) as Map<String, dynamic>;
      final type = data['type'] as String?;

      if (type == 'video') {
        final videoId = data['videoId'] as String?;
        if (videoId != null) {
          // Navigate to the video — the app can listen for this
          // For simplicity, we show a snackbar. Full navigation requires
          // the video model, which can be fetched by DatabaseService.
          navigatorKey.currentState?.pushNamed(
            '/video',
            arguments: videoId,
          );
        }
      }
    } catch (_) {
      // Payload wasn't JSON — treat as a simple message
      debugPrint('Notification tapped with payload: $payload');
    }
  }

  /// Returns the payload from a notification that started the app (if any).
  static String? get initialPayload => _initialPayload;

  // ── Firebase Cloud Messaging ───────────────────────────────────────────────

  Future<void> _setupFCM() async {
    // Request permission (iOS / Android 13+)
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission status: ${settings.authorizationStatus}');

    // Get the FCM token
    final token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground message: ${message.notification?.title}');
      showInstantNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: json.encode(message.data),
      );
    });

    // Handle notification tap when app is in background (but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM message opened app: ${message.data}');
      final payload = json.encode(message.data);
      _handlePayloadNavigation(payload);
    });

    // Handle notification that opened the app from a terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _initialPayload = json.encode(initialMessage.data);
    }

    // Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
