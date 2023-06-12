//
//  RootView.swift
//  AD_UI
//
//  Created by minii on 2023/06/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct RootView: View {
  @State var isTapStartButton: Bool = false
  
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      Group {
        if !isTapStartButton {
          OnBoardingView(isTapStartButton: $isTapStartButton)
        } else {
          MakeADView()
        }
      }
      .environment(\.mainWindowSize, proxy.size)
      .environment(\.mainWindowRect, .init(origin: .init(), size: proxy.size))
    }
  }
}

/// Use Like
/// @Environment(\.mainWindowSize) var mainWindowSize
private struct MainWindowSizeKey: EnvironmentKey {
  static let defaultValue: CGSize = .zero
}

private struct MainWindowRectKey: EnvironmentKey {
  static let defaultValue: CGRect = .zero
}

extension EnvironmentValues {
  var mainWindowSize: CGSize {
    get { self[MainWindowSizeKey.self] }
    set { self[MainWindowSizeKey.self] = newValue }
  }
  
  var mainWindowRect: CGRect {
    get { self[MainWindowRectKey.self] }
    set { self[MainWindowRectKey.self] = newValue }
  }
}
