import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

// Background message handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error in background handler: $e');
    return;
  }
  print('Handling a background message: ${message.messageId}');

  // Show notification for background messages
  if (message.notification != null) {
    // Extract custom sound from message data
    String? customSound = message.data['sound'];
    if (customSound != null) {
      await NotificationService.showNotification(
        message.notification!.title ?? 'New Notification',
        message.notification!.body ?? '',
        soundFileName: customSound,
      );
    } else {
      {
        await NotificationService.showNotification(
          message.notification!.title ?? 'New Notification',
          message.notification!.body ?? '',
        );
      }
    }
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static String? _fcmToken;
  static String? _apnsToken;
  static String? get fcmToken => _fcmToken;

  static Future<void> initialize() async {
    // Initialize Firebase with default options from google-services.json
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase initialization error: $e');
      // If initialization fails, try to continue without Firebase
      // The app should still work even if Firebase is not available
      return;
    }

    // Request permission for iOS
    await _requestPermission();

    // Retrieve APNS token on iOS (required for some FCM features)
    await _getAPNSToken();
    // Get FCM token
    await _getFCMToken();

    // Configure local notifications
    await _initializeLocalNotifications();

    // Setup message handlers
    await _setupMessageHandlers();

    print('NotificationService initialized successfully');
  }

  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          notificationCategories: [
            DarwinNotificationCategory(
              'general',
              actions: <DarwinNotificationAction>[
                DarwinNotificationAction.plain('view', 'View'),
              ],
            ),
          ],
        );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      // Create a default channel without a custom sound. Per-notification
      // custom sounds will create their own channel dynamically so that
      // Android (Oreo+) will play the expected sound.
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'broker_channel_id',
        'AG Broker Notifications',
        description: 'This channel is used for AG Broker app notifications',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  static Future<void> _getFCMToken() async {
    try {
      // On iOS with APNS integration, ensure APNS token is available first.
      if (Platform.isIOS) {
        const int maxAttempts = 6;
        int attempt = 0;
        while ((_apnsToken == null || _apnsToken!.isEmpty) &&
            attempt < maxAttempts) {
          // Try to fetch APNS token again from the plugin
          _apnsToken = await _firebaseMessaging.getAPNSToken();
          if (_apnsToken != null && _apnsToken!.isNotEmpty) break;
          attempt++;
          await Future.delayed(Duration(milliseconds: 500));
        }
        if (_apnsToken == null || _apnsToken!.isEmpty) {
          print(
            'APNS token still not available after retries; continuing to get FCM token (may fail on simulator)',
          );
        }
      }

      _fcmToken = await _firebaseMessaging.getToken();
      print('FCM Token: $_fcmToken');

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('FCM Token refreshed: $newToken');
        // TODO: Send token to your server
      });
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  // Get APNS token for iOS devices. On simulators this will usually be null.
  static Future<void> _getAPNSToken() async {
    try {
      if (Platform.isIOS) {
        _apnsToken = await _firebaseMessaging.getAPNSToken();
        print('APNS Token: $_apnsToken');

        // Listen for APNS token refresh if available
        _firebaseMessaging.onTokenRefresh.listen((_) async {
          // when FCM token refreshes, APNS token may also change; fetch again
          final newApns = await _firebaseMessaging.getAPNSToken();
          _apnsToken = newApns;
          print('APNS Token refreshed: $_apnsToken');
        });
      } else {
        print('Not an iOS device — skipping APNS token retrieval');
      }
    } catch (e) {
      print('Error getting APNS token: $e');
    }
  }

  static Future<void> _setupMessageHandlers() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Extract custom sound from message data
        String? customSound = message.data['sound'];
        showNotification(
          message.notification!.title ?? 'New Notification',
          message.notification!.body ?? '',
          payload: message.data.toString(),
          soundFileName: customSound,
        );
      }
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      _handleMessage(message);
    });

    // Check if app was opened from a terminated state via notification
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  static void _handleMessage(RemoteMessage message) {
    print('Handling message: ${message.data}');
    // TODO: Navigate to specific screen based on notification data
    // Example: if (message.data['type'] == 'bid') { navigate to bids }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // TODO: Handle notification tap and navigate to appropriate screen
  }

  static Future<void> showNotification(
    String title,
    String body, {
    String? payload,
    String? soundFileName, // Custom sound from Firebase
  }) async {
    // Validate and sanitize the sound parameter
    String androidSound = 'notification_sound'; // default
    String iosSound = 'notification_sound.mp3'; // default

    if (soundFileName != null && soundFileName.trim().isNotEmpty) {
      // Remove any file extensions if provided
      String sanitizedSound = soundFileName
          .trim()
          .toLowerCase()
          .replaceAll('.wav', '')
          .replaceAll('.mp3', '')
          .replaceAll('.ogg', '')
          .replaceAll('.aiff', '')
          .replaceAll('.caf', '');

      // Validate sound name (alphanumeric and underscores only)
      if (RegExp(r'^[a-z0-9_]+$').hasMatch(sanitizedSound)) {
        androidSound = sanitizedSound;
        iosSound = '$sanitizedSound.mp3';
        print('Using custom notification sound: $sanitizedSound');
      } else {
        print('Invalid sound name "$soundFileName". Using default sound.');
      }
    } else {
      print('No sound specified. Using default notification sound.');
    }

    // On Android (Oreo+) notification sound is tied to the NotificationChannel.
    // Create (or recreate) a channel specific to this sound so the system
    // will play the expected file. The channel id is derived from the sound
    // name to allow multiple different sounds in the app.
    String androidChannelId = 'broker_channel_id';
    String androidChannelName = 'AG Broker Notifications';

    if (Platform.isAndroid) {
      androidChannelId = 'broker_channel_$androidSound';
      androidChannelName = 'AG Broker Notifications ($androidSound)';

      try {
        final AndroidNotificationChannel dynamicChannel =
            AndroidNotificationChannel(
              androidChannelId,
              androidChannelName,
              description: 'Channel for $androidSound notifications',
              importance: Importance.high,
              playSound: true,
              enableVibration: true,
              sound: RawResourceAndroidNotificationSound(androidSound),
            );

        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(dynamicChannel);
      } catch (e) {
        // If creating a channel with the requested sound fails (missing
        // resource, etc.), fall back to the default channel id.
        print('Failed to create dynamic channel for $androidSound: $e');
        androidChannelId = 'broker_channel_id';
        androidChannelName = 'AG Broker Notifications';
      }
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          androidChannelId,
          androidChannelName,
          channelDescription:
              'This channel is used for AG Broker app notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(androidSound),
        );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: iosSound,
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      print('Error showing notification: $e');
      // If custom sound fails, try again with default sound
      if (androidSound != 'notification_sound') {
        print('Retrying with default sound...');
        final fallbackAndroid = AndroidNotificationDetails(
          'broker_channel_id',
          'AG Broker Notifications',
          channelDescription:
              'This channel is used for AG Broker app notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        );

        final fallbackIOS = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification_sound.mp3',
        );

        await _flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title,
          body,
          NotificationDetails(android: fallbackAndroid, iOS: fallbackIOS),
          payload: payload,
        );
      } else {
        rethrow;
      }
    }
  }

  // Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  // Delete FCM token
  static Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    _fcmToken = null;
    print('FCM token deleted');
  }
}
