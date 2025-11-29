import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var notificationChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up notification method channel after Flutter engine is ready
    if let controller = window?.rootViewController as? FlutterViewController {
      setupNotificationChannel(controller: controller)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Ensure channel is set up if not already done
    if let controller = window?.rootViewController as? FlutterViewController {
      setupNotificationChannel(controller: controller)
    }
  }
  
  private func setupNotificationChannel(controller: FlutterViewController) {
    // Only set up once
    guard notificationChannel == nil else { return }
    
    notificationChannel = FlutterMethodChannel(
      name: "com.hackathon/notifications",
      binaryMessenger: controller.binaryMessenger
    )
    
    notificationChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else {
        result(FlutterError(code: "UNAVAILABLE", message: "AppDelegate not available", details: nil))
        return
      }
      
      switch call.method {
      case "requestPermissions":
        self.requestNotificationPermissions(result: result)
      case "showNotification":
        self.showNotification(call: call, result: result)
      case "cancelNotification":
        self.cancelNotification(call: call, result: result)
      case "cancelAllNotifications":
        self.cancelAllNotifications(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func requestNotificationPermissions(result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          result(FlutterError(code: "PERMISSION_ERROR", message: error.localizedDescription, details: nil))
        } else {
          result(granted)
        }
      }
    }
  }
  
  private func showNotification(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let id = args["id"] as? Int,
          let title = args["title"] as? String,
          let body = args["body"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
      return
    }
    
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
    
    let request = UNNotificationRequest(
      identifier: "\(id)",
      content: content,
      trigger: nil // Show immediately
    )
    
    center.add(request) { error in
      DispatchQueue.main.async {
        if let error = error {
          result(FlutterError(code: "NOTIFICATION_ERROR", message: error.localizedDescription, details: nil))
        } else {
          result(true)
        }
      }
    }
  }
  
  private func cancelNotification(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let id = args["id"] as? Int else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
      return
    }
    
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(id)"])
    center.removeDeliveredNotifications(withIdentifiers: ["\(id)"])
    
    result(true)
  }
  
  private func cancelAllNotifications(result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
    result(true)
  }
}
