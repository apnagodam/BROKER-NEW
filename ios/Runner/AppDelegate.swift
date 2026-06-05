import Flutter
import UIKit
import flutter_local_notifications
import Firebase
import UserNotifications
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
         UNUserNotificationCenter.current().delegate = self
         application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)
      // This is required to make any communication available in the action isolate.
       FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
         GeneratedPluginRegistrant.register(with: registry)
       }
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
      }
}
