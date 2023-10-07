//
//  SwitchView.swift
//  RootView
//
//  Created by minii on 2023/10/07.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import MakeAD
import ConfigureAnimation

struct SwitchHostingUIView<H: View, S: Equatable>: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIViewController
  let vc: UIHostingController<H>
  let switchValue: S
  let mySwitchValue: S

  init(
    vc: UIHostingController<H>,
    switchValue: S,
    mySwitchValue: S
  ) {
    self.vc = vc
    self.switchValue = switchValue
    self.mySwitchValue = mySwitchValue
  }

  func makeUIViewController(context: Context) -> UIViewController {
    vc.view.isHidden = switchValue != mySwitchValue
    return vc
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    uiViewController.view.isHidden = switchValue != mySwitchValue
  }
}

struct SwitchHostingView<H: View, S: Equatable>: View {
  let vc: UIHostingController<H>
  let switchValue: S
  let mySwitchValue: S

  init(
    vc: UIHostingController<H>,
    switchValue: S,
    mySwitchValue: S
  ) {
    self.vc = vc
    self.switchValue = switchValue
    self.mySwitchValue = mySwitchValue
  }
  
  var body: some View {
    SwitchHostingUIView(vc: vc, switchValue: switchValue, mySwitchValue: mySwitchValue)
      .disabled(switchValue != mySwitchValue)
  }
}

enum ADViewCase: Equatable {
  case MakeAD
  case ConfigureAnimation
}

struct SwitchView: View {
  let makeADViewController: UIHostingController<MakeADView> = .init(
    rootView: MakeADView()
  )
  let configureAnimationViewController: UIHostingController<ConfigureAnimationView> = .init(
    rootView: ConfigureAnimationView()
  )
  
  let switchValue: ADViewCase
  
  init(switchValue: ADViewCase) {
    self.switchValue = switchValue
  }
  
  var body: some View {
    ZStack {
      SwitchHostingView(
        vc: makeADViewController,
        switchValue: switchValue,
        mySwitchValue: ADViewCase.MakeAD
      )
      SwitchHostingView(
        vc: configureAnimationViewController,
        switchValue: switchValue,
        mySwitchValue: ADViewCase.ConfigureAnimation
      )
    }
  }
}
