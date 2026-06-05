# Custom Notification Sound Setup

## Prerequisites

1. **Add your sound file** to `assets/sounds/` directory
   - Name it `notification_sound.mp3` (or `.wav`)
   - Supported formats:
     - Android: `.mp3`, `.wav`, `.ogg`
     - iOS: `.aiff`, `.wav`, `.caf`
   - Keep file size small (< 5 seconds recommended)

## Android Setup

For Android, the sound file needs to be in the `res/raw` directory:

1. Create the directory if it doesn't exist:
   ```
   android/app/src/main/res/raw/
   ```

2. Copy your sound file to this directory:
   ```bash
   cp assets/sounds/notification_sound.mp3 android/app/src/main/res/raw/notification_sound.mp3
   ```

3. **Important**: The filename should NOT include the extension when referenced in code
   - File: `notification_sound.mp3`
   - Reference in code: `notification_sound` (without .mp3)

4. The sound will be automatically used by the `RawResourceAndroidNotificationSound` configuration

### Android Sound Format Requirements:
- Supported: MP3, WAV, OGG
- Duration: < 5 seconds recommended
- Bitrate: 128kbps or lower
- Sample rate: 44.1kHz or 48kHz

## iOS Setup

For iOS, you need to add the sound file to the Xcode project:

1. Open the iOS project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. In Xcode, right-click on the "Runner" folder in the project navigator

3. Select "Add Files to Runner..."

4. Navigate to `assets/sounds/` and select your `notification_sound.mp3` file

5. **Important**: In the dialog, make sure:
   - ✅ "Copy items if needed" is checked
   - ✅ "Create groups" is selected
   - ✅ "Runner" target is checked

6. The sound file will be added to the bundle and referenced by name in code

### iOS Sound Format Requirements:
- Supported: AIFF, WAV, CAF (MP3 also works but CAF is recommended)
- Duration: < 30 seconds (longer sounds are truncated)
- Linear PCM or IMA4 audio recommended
- Convert MP3 to CAF for best compatibility:
  ```bash
  afconvert notification_sound.mp3 notification_sound.caf -d ima4 -f caff -v
  ```

## Testing

### Test on Android:
```bash
flutter run -d <android-device-id>
```
Send a test notification to hear the custom sound.

### Test on iOS:
```bash
flutter run -d <ios-device-id>
```
Send a test notification to hear the custom sound.

### Troubleshooting:

**Android:**
- If sound doesn't play, check that the file is in `android/app/src/main/res/raw/`
- Verify filename has no spaces or special characters
- Check Android logs: `adb logcat | grep -i notification`
- Try uninstalling and reinstalling the app

**iOS:**
- If sound doesn't play, verify the file was added to the Xcode project
- Check that "Copy items if needed" was selected
- Verify the target membership includes "Runner"
- Check iOS logs in Xcode console
- Make sure notification permissions are granted

**Both Platforms:**
- Ensure device is not in silent/Do Not Disturb mode
- Check notification settings allow sound
- Verify the sound file format is compatible
- File should be < 5 seconds for best results

## Using Different Sounds for Different Notifications

You can modify the `showNotification` method to accept a custom sound parameter:

```dart
static Future<void> showNotification(
  String title,
  String body, {
  String? payload,
  String soundFileName = 'notification_sound', // default sound
}) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'broker_channel_id',
        'Broker Notifications',
        channelDescription:
            'This channel is used for broker app notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundFileName),
      );

  final DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: '$soundFileName.mp3',
      );

  // ... rest of the method
}
```

Then call it with different sounds:
```dart
NotificationService.showNotification(
  'Important Alert',
  'This is urgent',
  soundFileName: 'alert_sound',
);
```
