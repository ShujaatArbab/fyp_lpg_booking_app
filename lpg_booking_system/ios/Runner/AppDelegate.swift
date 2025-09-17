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
<<<<<<< HEAD
<<<<<<< HEAD
    GMSServices.provideAPIKey("REMOVED_KEY")
=======
>>>>>>> 6b0be65 (update)
=======
>>>>>>> 6b0be65b97d3007188a1a14956f167ac4559507d
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
