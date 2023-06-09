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
    if isTapStartButton {
      UploadADrawingView()
    } else {
      OnBoardingView(isTapStartButton: $isTapStartButton)
    }
  }
}
