//
//  SwitchView.swift
//  RootView
//
//  Created by minii on 2023/10/07.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

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
