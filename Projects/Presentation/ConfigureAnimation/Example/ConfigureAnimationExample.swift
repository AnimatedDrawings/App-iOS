//
//  ConfigureAnimationExample.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import GoogleMobileAds
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    MobileAds.shared.requestConfiguration.testDeviceIdentifiers =
    [ "3a00757931103334eb04e79bb0455b31" ] // Sample device ID
    
    MobileAds.shared.start { status in
      for (adapter, info) in status.adapterStatusesByClassName {
        print("\(adapter): \(info.state) – \(info.description)")
      }
    }
    return true
  }
}

@main
struct ConfigureAnimationExample: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      // RewardAdView()
      //      MockConfigureAnimationView()
      TestADMobView()
    }
  }
}
