# Firebase Cloud Messaging Setup Guide

## Firebase Notifications Implementation

Firebase Cloud Messaging (FCM) has been integrated into the Broker app. Follow these steps to complete the setup:

## 1. Firebase Console Setup

### Create/Configure Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing project
3. Add your Android and iOS apps to the project

### Android Setup
1. In Firebase Console, click "Add app" → Android
2. Enter your package name: `com.example.broker` (or your actual package name from `android/app/build.gradle.kts`)
3. Download `google-services.json`
4. Place it in `android/app/` directory

### iOS Setup
1. In Firebase Console, click "Add app" → iOS
2. Enter your bundle ID from `ios/Runner.xcodeproj/project.pbxproj`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

## 2. Android Configuration

### Update `android/app/build.gradle.kts`
Add the Google services plugin:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this line
}
```

### Update `android/build.gradle.kts`
Add the classpath in buildscript dependencies:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### Update `android/app/src/main/AndroidManifest.xml`
Add permissions and metadata:
```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application>
        <!-- Add this meta-data inside application tag -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="broker_channel_id" />
            
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher" />
    </application>
</manifest>
```

## 3. iOS Configuration

### Update `ios/Podfile`
Ensure platform version is at least 13.0:
```ruby
platform :ios, '13.0'
```

### Add Capabilities in Xcode
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner → Signing & Capabilities
3. Click "+ Capability"
4. Add "Push Notifications"
5. Add "Background Modes" and check "Remote notifications"

### Update `ios/Runner/Info.plist`
Add notification permissions:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

## 4. Features Implemented

### Notification Handling
- ✅ **Foreground notifications**: Shows local notification when app is active
- ✅ **Background notifications**: Handled automatically by FCM
- ✅ **Terminated state**: Opens app when notification is tapped
- ✅ **Notification tapping**: Handles navigation based on payload

### Available Methods
```dart
// Get FCM token
String? token = NotificationService.fcmToken;

// Show local notification
await NotificationService.showNotification(
  'Title',
  'Body',
  payload: 'optional_data',
);

// Subscribe to topic
await NotificationService.subscribeToTopic('all_users');

// Unsubscribe from topic
await NotificationService.unsubscribeFromTopic('all_users');

// Delete FCM token (on logout)
await NotificationService.deleteToken();
```

## 5. Testing Notifications

### Using Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter notification title and text
4. Select your app
5. Send test message to device using FCM token (printed in console)

### Send via API/Backend
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "New Bid",
      "body": "A new bid has been placed"
    },
    "data": {
      "type": "bid",
      "id": "123"
    }
  }'
```

## 6. Next Steps

### Customize Notification Handling
Edit `_handleMessage()` in `notification_service.dart` to navigate to specific screens:
```dart
static void _handleMessage(RemoteMessage message) {
  if (message.data['type'] == 'bid') {
    // Navigate to bids screen
  } else if (message.data['type'] == 'order') {
    // Navigate to orders screen
  }
}
```

### Backend Integration
- Send FCM token to your backend after login
- Backend should send notifications based on events (new bids, matched orders, etc.)
- Update token when it refreshes

## 7. Important Notes

⚠️ **For iOS**: You need an Apple Developer account to test push notifications on physical devices
⚠️ **For Android**: Notifications work on emulator and physical devices
⚠️ **FCM Token**: The token is printed in console - use it for testing
⚠️ **Background Handler**: Must be a top-level function (cannot be inside a class)

## Troubleshooting

### Notifications not showing on Android
- Check `google-services.json` is in `android/app/`
- Verify notification permissions are granted
- Check channel ID matches in all places

### Notifications not showing on iOS
- Ensure capabilities are added in Xcode
- Check `GoogleService-Info.plist` is in `ios/Runner/`
- Test on physical device (push notifications don't work on simulator)

### Token not generating
- Check Firebase initialization in console logs
- Verify internet connection
- Check Firebase project configuration
