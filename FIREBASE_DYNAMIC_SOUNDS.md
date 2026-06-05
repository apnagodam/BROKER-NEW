# Firebase Dynamic Notification Sounds

Your app now supports different notification sounds based on Firebase message data.

## How It Works

The notification service automatically extracts the `sound` field from Firebase message data and uses it to play the appropriate sound file.

## Sending Notifications from Firebase

### Using Firebase Console

When sending notifications via Firebase Console, add a custom data field:

1. Go to Firebase Console → Cloud Messaging
2. Create a new notification
3. Under "Additional options" → "Custom data"
4. Add key: `sound`, value: `your_sound_name` (without extension for Android)

### Using Firebase Admin SDK (Backend)

#### Node.js Example:

```javascript
const admin = require('firebase-admin');

// Send notification with default sound
await admin.messaging().send({
  token: userDeviceToken,
  notification: {
    title: 'New Message',
    body: 'You have a new message'
  },
  data: {
    sound: 'notification_sound' // Default sound
  }
});

// Send notification with custom sound (e.g., urgent alert)
await admin.messaging().send({
  token: userDeviceToken,
  notification: {
    title: 'Urgent Alert!',
    body: 'This requires immediate attention'
  },
  data: {
    sound: 'urgent_alert' // Custom sound
  }
});

// Send notification with different sound (e.g., new bid)
await admin.messaging().send({
  token: userDeviceToken,
  notification: {
    title: 'New Bid Received',
    body: 'Someone placed a bid on your property'
  },
  data: {
    sound: 'bid_received' // Another custom sound
  }
});
```

#### Python Example:

```python
from firebase_admin import messaging

# Send notification with custom sound
message = messaging.Message(
    notification=messaging.Notification(
        title='New Message',
        body='You have a new message',
    ),
    data={
        'sound': 'urgent_alert',  # Custom sound name
    },
    token=user_device_token,
)

response = messaging.send(message)
```

#### PHP Example:

```php
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

$message = CloudMessage::withTarget('token', $deviceToken)
    ->withNotification(Notification::create('New Message', 'You have a new message'))
    ->withData([
        'sound' => 'urgent_alert'  // Custom sound name
    ]);

$messaging->send($message);
```

## Sound File Setup

### Available Sounds

Create different sound files for different notification types:

```
assets/sounds/
├── notification_sound.mp3    (default)
├── urgent_alert.mp3          (urgent notifications)
├── bid_received.mp3          (bid notifications)
├── message_received.mp3      (message notifications)
└── reminder.mp3              (reminder notifications)
```

### Android Setup

Copy all sound files to Android's raw resources:

```bash
mkdir -p android/app/src/main/res/raw
cp assets/sounds/*.mp3 android/app/src/main/res/raw/
```

**Important**: 
- File names must be lowercase
- No spaces or special characters (use underscores)
- Don't include the `.mp3` extension in the Firebase data

### iOS Setup

1. Open Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Drag all sound files from `assets/sounds/` into the Runner folder
3. Make sure "Copy items if needed" is checked
4. Verify "Runner" target is selected

## Example Use Cases

### Notification Types with Different Sounds

```javascript
// 1. New Bid Notification
{
  notification: {
    title: 'New Bid',
    body: 'Someone bid on your property'
  },
  data: {
    sound: 'bid_received',
    type: 'bid',
    bidId: '12345'
  }
}

// 2. Urgent Alert
{
  notification: {
    title: 'Urgent!',
    body: 'Action required immediately'
  },
  data: {
    sound: 'urgent_alert',
    type: 'urgent'
  }
}

// 3. Message Notification
{
  notification: {
    title: 'New Message',
    body: 'You have a new message'
  },
  data: {
    sound: 'message_received',
    type: 'message',
    senderId: '67890'
  }
}

// 4. Default Sound (no sound specified)
{
  notification: {
    title: 'Notification',
    body: 'General notification'
  },
  data: {
    type: 'general'
    // No sound field - uses default 'notification_sound'
  }
}
```

## Testing Locally

You can test different sounds locally:

```dart
// In your code
NotificationService.showNotification(
  'Test Urgent',
  'This is an urgent test',
  soundFileName: 'urgent_alert',
);

NotificationService.showNotification(
  'Test Message',
  'This is a message test',
  soundFileName: 'message_received',
);

// Default sound
NotificationService.showNotification(
  'Test Default',
  'This uses default sound',
);
```

## Fallback Behavior

- If `sound` field is missing or empty → uses `notification_sound` (default)
- If specified sound file doesn't exist → uses system default sound
- Android: Sound file must exist in `res/raw/`
- iOS: Sound file must be in Xcode project bundle

## Sound Format Requirements

### Android:
- Format: MP3, WAV, OGG
- Duration: < 5 seconds recommended
- File size: < 1MB
- Naming: lowercase, no spaces (e.g., `urgent_alert.mp3`)

### iOS:
- Format: AIFF, WAV, CAF, or MP3
- Duration: < 30 seconds
- Convert to CAF for best compatibility:
  ```bash
  afconvert urgent_alert.mp3 urgent_alert.caf -d ima4 -f caff -v
  ```

## Troubleshooting

### Sound Not Playing

1. **Check sound file exists**:
   - Android: `android/app/src/main/res/raw/[soundname].mp3`
   - iOS: Added to Xcode project

2. **Verify sound name in Firebase data**:
   - Android: No extension (e.g., `urgent_alert`, not `urgent_alert.mp3`)
   - iOS: Will add `.mp3` automatically

3. **Check device settings**:
   - Not in silent mode
   - Notifications enabled
   - Sound permission granted

4. **Test with logs**:
   ```bash
   # Android
   adb logcat | grep -i notification
   
   # iOS
   # Check Xcode console for errors
   ```

5. **Reinstall app** (if sound file was added after installation)

### Common Issues

- **"Resource not found"**: Sound file not in `res/raw/` (Android) or Xcode project (iOS)
- **Wrong extension**: For Android Firebase data, use name without extension
- **Case mismatch**: Ensure sound name matches file name exactly
- **File format**: Use compatible formats (MP3 works for both platforms)

## Best Practices

1. Keep sound files short (2-3 seconds)
2. Use descriptive names (e.g., `bid_alert` not `sound1`)
3. Test on both Android and iOS devices
4. Provide fallback to default sound
5. Keep file sizes small
6. Use consistent naming across platforms
