import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


    GMSServices.provideAPIKey("AIzaSyA1KvqmxrPp7HkLx6Zqq_d6mQE1XzrWcj0")

 (update)


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
