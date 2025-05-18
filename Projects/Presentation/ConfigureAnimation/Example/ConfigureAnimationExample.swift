//
//  ConfigureAnimationExample.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import GoogleMobileAds
import SwiftUI

@main
struct ConfigureAnimationExample: App {
  init() {
    MobileAds.shared.start(completionHandler: nil)
  }

  var body: some Scene {
    WindowGroup {
      // RewardAdView()
//      MockConfigureAnimationView()
      TestADMobView()
    }
  }
}
