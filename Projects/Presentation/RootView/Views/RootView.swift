//
//  RootView.swift
//  AD_UI
//
//  Created by minii on 2023/06/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import OnBoarding
import MakeAD
import ConfigureAnimation
import SharedProvider
import DomainModel

let onBoardingViewController: UIHostingController<OnBoardingView> = .init(
  rootView: OnBoardingView()
)
let makeADViewController: UIHostingController<MakeADView> = .init(
  rootView: MakeADView()
)
let configureAnimationViewController: UIHostingController<ConfigureAnimationView> = .init(
  rootView: ConfigureAnimationView()
)

public struct RootView: View {
  public init() {}
  
  @SharedValue(\.adViewState.currentView) var currentView
  
  public var body: some View {
    ZStack {
      SwitchHostingView(
        vc: onBoardingViewController,
        switchValue: currentView,
        mySwitchValue: ADViewCase.OnBoarding
      )
      SwitchHostingView(
        vc: makeADViewController,
        switchValue: currentView,
        mySwitchValue: ADViewCase.MakeAD
      )
      SwitchHostingView(
        vc: configureAnimationViewController,
        switchValue: currentView,
        mySwitchValue: ADViewCase.ConfigureAnimation
      )
    }
    .ignoresSafeArea()
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
