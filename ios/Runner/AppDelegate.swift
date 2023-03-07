import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    window?.rootViewController?.view.endEditing(true);
    window?.rootViewController?.view.endEditing(true);
    self.window.isHidden = true;
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    self.window.isHidden = false;
  }
}
