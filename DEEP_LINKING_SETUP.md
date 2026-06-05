# Deep Linking Setup Guide

This app now supports deep linking through Android App Links, iOS Universal Links, and custom URL schemes.

## 📱 Supported Deep Links

### Routes
- `https://your-domain.com/` → Home or Login (based on auth state)
- `https://your-domain.com/login` → Login page
- `https://your-domain.com/home` → Home page
- `https://your-domain.com/stack-details` → Stack details (requires passing stack data)
- `broker://` → Custom URL scheme for all routes

### Examples
```
https://broker.example.com/login
https://broker.example.com/home
broker://login
broker://home
```

## 🔧 Configuration Steps

### 1. Update Domain Information

Replace `broker.example.com` with your actual domain in:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<data android:scheme="https" android:host="YOUR_DOMAIN.com" />
<data android:scheme="http" android:host="YOUR_DOMAIN.com" />
```

**iOS** - You'll need to add Associated Domains in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target → Signing & Capabilities
3. Click "+ Capability" → Add "Associated Domains"
4. Add: `applinks:YOUR_DOMAIN.com`

### 2. Get Android SHA-256 Certificate Fingerprint

Run this command to get your SHA-256 fingerprint:
```bash
# For debug build
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release build (use your keystore path)
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
```

Update `web/.well-known/assetlinks.json` with your fingerprint:
```json
{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "YOUR_PACKAGE_NAME",
    "sha256_cert_fingerprints": [
      "YOUR_SHA256_FINGERPRINT_HERE"
    ]
  }
}
```

### 3. Update iOS Team ID

Get your Team ID from:
- Apple Developer Account → Membership
- Or from Xcode: Runner target → General → Team

Update `web/.well-known/apple-app-site-association`:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "YOUR_TEAM_ID.YOUR_BUNDLE_ID",
        "paths": [...]
      }
    ]
  }
}
```

### 4. Update Package Name / Bundle ID

**Android** - Check/update in `android/app/build.gradle.kts`:
```kotlin
namespace = "YOUR.PACKAGE.NAME"
```

**iOS** - Check/update in Xcode:
Runner target → General → Bundle Identifier

Update both verification files with your package name/bundle ID.

### 5. Host Verification Files

Upload these files to your domain:
- `https://your-domain.com/.well-known/assetlinks.json` (Android)
- `https://your-domain.com/.well-known/apple-app-site-association` (iOS)

**Important:**
- Files must be served over HTTPS
- `assetlinks.json` content type: `application/json`
- `apple-app-site-association` content type: `application/json` (no file extension)
- Files must be publicly accessible (no authentication required)

### 6. Update Custom URL Scheme (Optional)

If you want a different custom scheme instead of `broker://`:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<data android:scheme="YOUR_SCHEME" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>YOUR_SCHEME</string>
</array>
```

## 🧪 Testing Deep Links

### Android Testing

1. **Install the app** on your device/emulator
2. **Test via ADB:**
   ```bash
   # Test HTTPS link
   adb shell am start -W -a android.intent.action.VIEW \
     -d "https://your-domain.com/login" com.example.broker

   # Test custom scheme
   adb shell am start -W -a android.intent.action.VIEW \
     -d "broker://login" com.example.broker
   ```

3. **Verify App Links:**
   ```bash
   adb shell pm get-app-links com.example.broker
   ```

### iOS Testing

1. **Install the app** via Xcode or TestFlight
2. **Test via Terminal:**
   ```bash
   xcrun simctl openurl booted "https://your-domain.com/login"
   xcrun simctl openurl booted "broker://login"
   ```

3. **Test on device:**
   - Send yourself a text message with the link
   - Tap the link in Notes app
   - Use Safari and navigate to the URL

### Web Testing

Create a simple HTML test page:
```html
<!DOCTYPE html>
<html>
<body>
  <h2>Deep Link Testing</h2>
  <a href="https://your-domain.com/login">Open Login</a><br/>
  <a href="https://your-domain.com/home">Open Home</a><br/>
  <a href="broker://login">Open with Custom Scheme</a>
</body>
</html>
```

## 🔍 Verification

### Verify Android App Links
Visit: `https://your-domain.com/.well-known/assetlinks.json`

Use Google's verification tool:
https://developers.google.com/digital-asset-links/tools/generator

### Verify iOS Universal Links
Visit: `https://your-domain.com/.well-known/apple-app-site-association`

Use Apple's validator:
https://search.developer.apple.com/appsearch-validation-tool/

## 📝 Notes

- **Android:** App Links require `android:autoVerify="true"` (already added)
- **iOS:** Universal Links require the app to be signed with a valid provisioning profile
- **Testing locally:** Use ngrok or similar service to test with a public HTTPS URL
- **Production:** Ensure verification files are cached properly (max 7 days for Apple)

## 🐛 Troubleshooting

### Android Not Opening App
1. Clear default app associations: Settings → Apps → Default apps
2. Verify assetlinks.json is accessible
3. Check SHA-256 fingerprint matches
4. Reinstall the app after configuration changes

### iOS Not Opening App
1. Verify Associated Domains capability is added
2. Check apple-app-site-association is accessible
3. Verify Team ID and Bundle ID are correct
4. Wait a few minutes after first install (iOS caches the association)
5. Try uninstall/reinstall

### Links Open in Browser Instead
- Verify verification files are properly hosted
- Check that domain matches exactly in all configs
- Ensure app is installed and signed correctly
- Try clearing cache and reinstalling

## 📚 Additional Resources

- [Android App Links](https://developer.android.com/training/app-links)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
- [Flutter Deep Linking](https://docs.flutter.dev/ui/navigation/deep-linking)
- [GoRouter Deep Linking](https://pub.dev/documentation/go_router/latest/topics/Deep%20linking-topic.html)
