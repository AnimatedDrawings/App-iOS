//
//  ConfigureAnimationExample.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import GoogleMobileAds
import SwiftUI


class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    MobileAds.shared.start(completionHandler: nil)
    return true
  }
}

@main
struct ConfigureAnimationExample: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
//      RewardAdView()
      MockConfigureAnimationView()
    }
  }
}
