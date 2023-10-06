//
//  StepStatusBar.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import SharedProvider

public struct StepStatusBar: View {
  public init() {}
  
  @State var statusBarWidth: CGFloat = 0
  let statusBarSpacing: CGFloat = 4
  let activeColor: Color = ADUIKitAsset.Color.blue1.swiftUIColor
  let inActiveColor: Color = .gray
  let completeColor: Color = ADUIKitAsset.Color.green1.swiftUIColor
  
  @SharedValue(\.shared.stepBar.currentStep) var currentStep
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  
  var currentStepIdx: Int {
    currentStep.rawValue
  }
  var completeStepIdx: Int {
    completeStep.rawValue
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Title()
      StatusBar()
    }
  }
}

extension StepStatusBar {
  @ViewBuilder
  func Title() -> some View {
    HStack(spacing: 20) {
      Text("S T E P")
      Text("\(currentStepIdx) / 4")
    }
    .fontWeight(.semibold)
  }
}

extension StepStatusBar {
  @ViewBuilder
  func StatusBar() -> some View {
    GeometryReader { geo in
      HStack(spacing: statusBarSpacing) {
        ForEach(1...4, id: \.self) { idx in
          Capsule()
            .foregroundColor(capsuleColor(idx))
            .frame(width: capsuleWidth(idx))
            .animation(.easeOut, value: self.currentStepIdx)
        }
      }
      .onAppear { calStatusBarWidth(proxy: geo) }
    }
    .frame(height: 8)
  }
  
  func calStatusBarWidth(proxy: GeometryProxy) {
    self.statusBarWidth = proxy.size.width - (statusBarSpacing * 3)
  }
  
  func capsuleColor(_ idx: Int) -> Color {
    if currentStepIdx == idx {
      return activeColor
    }
    if idx < completeStepIdx {
      return completeColor
    }
    return inActiveColor
  }
  
  func capsuleWidth(_ idx: Int) -> CGFloat {
    return currentStepIdx == idx ? self.statusBarWidth / 2 : self.statusBarWidth / 6
  }
}
