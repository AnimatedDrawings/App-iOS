//
//  ADBackground.swift
//  AD_UI
//
//  Created by minii on 2023/05/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitResources

/// Use
public extension View {
  func addADBackground(withStepBar: Bool) -> some View {
    self.modifier(ADBackgroundViewModifier(withStepBar: withStepBar))
  }
}

struct ADBackgroundViewModifier: ViewModifier {
  let withStepBar: Bool
  
  func body(content: Content) -> some View {
    ZStack {
      ADBackground(withStepBar: withStepBar)
      content
    }
  }
}

struct ADBackground: View {
  let withStepBar: Bool
  
  var body: some View {
    ADUIKitResourcesAsset.Color.blue4.swiftUIColor
      .overlay {
        WaveView()
      }
      .mask {
        RandomCurveView(withStepBar: withStepBar)
      }
      .ignoresSafeArea()
  }
}

// MARK: - Preview

import SharedProvider

#Preview {
  Preview_ADBackground()
}

struct Preview_ADBackground: View {
  @SharedValue(\.shared.stepBar.currentStep) var currentStep
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      Button {
        currentStep = currentStep == .UploadADrawing ? .FindingTheCharacter : .UploadADrawing
      } label: {
        Text("ADBackground")
          .frame(width: 300, height: 300)
          .background(Color.green)
      }
    }
    .addADBackground(withStepBar: true)
  }
}

