//
//  StepStatusBar.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils

struct StepStatusBar: View {
  @Binding var currentStep: Step
  @Binding var completeStep: Step
  @State var statusBarWidth: CGFloat = 0
  let statusBarSpacing: CGFloat = 4
  let activeColor: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  let inActiveColor: Color = .gray
  let completeColor: Color = ADUtilsAsset.Color.green1.swiftUIColor
  var currentStepIdx: Int {
    return self.currentStep.rawValue
  }
  var completeStepIdx: Int {
    return self.completeStep.rawValue
  }
  
  var body: some View {
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
    else if idx <= completeStepIdx {
      return completeColor
    }
    
    return inActiveColor
  }
  
  func capsuleWidth(_ idx: Int) -> CGFloat {
    return currentStepIdx == idx ? self.statusBarWidth / 2 : self.statusBarWidth / 6
  }
}

struct PreviewsStepStatusBar: View {
  @State var currentStep: Step = .UploadADrawing
  @State var completeStep: Step = .SeparatingCharacter
  var currentStepIdx: Int {
    return currentStep.rawValue
  }
  
  var body: some View {
    VStack(spacing: 100) {
      StepStatusBar(
        currentStep: $currentStep,
        completeStep: $completeStep
      )
        .padding()
      Button("MoveUp", action: moveUpAction)
      Button("MoveDown", action: moveDownAction)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .animation(.default, value: currentStep)
  }
  
  func moveUpAction() {
    var nexIdx = currentStepIdx + 1
    if nexIdx == 5 {
      nexIdx = 1
    }
    
    self.currentStep = Step(rawValue: nexIdx) ?? .UploadADrawing
  }
  
  func moveDownAction() {
    var nexIdx = currentStepIdx - 1
    if nexIdx == 0 {
      nexIdx = 4
    }
    
    self.currentStep = Step(rawValue: nexIdx) ?? .SeparatingCharacter
  }
}

struct StepStatusBar_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsStepStatusBar()
  }
}

