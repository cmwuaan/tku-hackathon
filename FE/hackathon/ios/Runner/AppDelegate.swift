import Flutter
import UIKit
import UserNotifications
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var notificationChannel: FlutterMethodChannel?
  private var audioChannel: FlutterMethodChannel?
  private var audioRecorder: AVAudioRecorder?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up method channels after Flutter engine is ready
    if let controller = window?.rootViewController as? FlutterViewController {
      setupNotificationChannel(controller: controller)
      setupAudioChannel(controller: controller)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Ensure channels are set up if not already done
    if let controller = window?.rootViewController as? FlutterViewController {
      setupNotificationChannel(controller: controller)
      setupAudioChannel(controller: controller)
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
  
  // MARK: - Audio Recording
  
  private func setupAudioChannel(controller: FlutterViewController) {
    // Only set up once
    guard audioChannel == nil else { return }
    
    audioChannel = FlutterMethodChannel(
      name: "com.hackathon/audio",
      binaryMessenger: controller.binaryMessenger
    )
    
    audioChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else {
        result(FlutterError(code: "UNAVAILABLE", message: "AppDelegate not available", details: nil))
        return
      }
      
      switch call.method {
      case "requestPermission":
        self.requestAudioPermission(result: result)
      case "startRecording":
        self.startRecording(call: call, result: result)
      case "stopRecording":
        self.stopRecording(result: result)
      case "getAmplitude":
        self.getAmplitude(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func requestAudioPermission(result: @escaping FlutterResult) {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
      DispatchQueue.main.async {
        result(granted)
      }
    }
  }
  
  private func startRecording(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let path = args["path"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
      return
    }
    
    do {
      // Configure audio session
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.record, mode: .default)
      try audioSession.setActive(true)
      
      // Create audio recorder
      let url = URL(fileURLWithPath: path)
      let settings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]
      
      audioRecorder = try AVAudioRecorder(url: url, settings: settings)
      audioRecorder?.isMeteringEnabled = true
      audioRecorder?.record()
      
      result(true)
    } catch {
      result(FlutterError(code: "RECORDING_ERROR", message: error.localizedDescription, details: nil))
    }
  }
  
  private func stopRecording(result: @escaping FlutterResult) {
    audioRecorder?.stop()
    audioRecorder = nil
    
    do {
      try AVAudioSession.sharedInstance().setActive(false)
      result(true)
    } catch {
      result(FlutterError(code: "STOP_ERROR", message: error.localizedDescription, details: nil))
    }
  }
  
  private func getAmplitude(result: @escaping FlutterResult) {
    guard let recorder = audioRecorder, recorder.isRecording else {
      result(0.0)
      return
    }
    
    recorder.updateMeters()
    let averagePower = recorder.averagePower(forChannel: 0)
    
    // Convert power to dB (already in dB, but normalize to 0-160 range)
    let normalizedDb = averagePower + 160.0
    result(max(0.0, normalizedDb))
  }
}
