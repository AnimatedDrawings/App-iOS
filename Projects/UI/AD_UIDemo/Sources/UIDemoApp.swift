//
//  UIDemo.swift
//  AD_UIDemo
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_UI

@main
struct UIDemoApp: App {
  let ui = OnBoardingView()
  
  var body: some Scene {
    WindowGroup {
//      ui.Main(startButtonAction: {})
      ADBackground()
    }
  }
}
