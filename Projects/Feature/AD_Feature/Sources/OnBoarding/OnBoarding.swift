//
//  OnBoarding.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import AD_UI
import AD_Utils

public struct OnBoarding: ADFeature {
  public var ui = OnBoardingView(startButtonAction: { print("123")} )
  
  public init() {}
  
  public var body: some View {
    ui.main()
  }
}

struct OnBoarding_Previews: PreviewProvider {
  static var previews: some View {
    OnBoarding()
  }
}
