//
//  Extension+UIWindow.swift
//  AD_Utils
//
//  Created by minii on 2023/08/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

// Use
// UIScreen.current?.bounds.size

public extension UIWindow {
  public static var current: UIWindow? {
    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene else { continue }
      for window in windowScene.windows {
        if window.isKeyWindow { return window }
      }
    }
    return nil
  }
}

public extension UIScreen {
  public static var current: UIScreen? {
    UIWindow.current?.screen
  }
}
