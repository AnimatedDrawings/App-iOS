//
//  RootExample.swift
//  RootExample
//
//  Created by minii on 2023/10/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import GoogleMobileAds
import SwiftUI

@main
struct RootExample: App {
  init() {
    MobileAds.shared.start(completionHandler: nil)
  }

  var body: some Scene {
    WindowGroup {
      MockRootView()
    }
  }
}
