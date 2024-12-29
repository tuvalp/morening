import Flutter
import UIKit
import UserNotifications
import alarm

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Set up user notifications delegate
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        
        // Register background tasks if needed
        SwiftAlarmPlugin.registerBackgroundTasks()
        
        // Set up Flutter MethodChannel for HotspotHelper
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "hotspot_helper",
                                               binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler { (call, result) in
                switch call.method {
                case "registerHotspotHelper":
                    HotspotHelperManager.registerHotspotHelper()
                    result(nil)
                case "scanNetworks":
                    // Implement scan networks if available
                    let networks = HotspotHelperManager.scanNetworks().map { $0.ssid }
                    result(networks)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
