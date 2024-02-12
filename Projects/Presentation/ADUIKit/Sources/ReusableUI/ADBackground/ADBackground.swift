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
  func addADBackground() -> some View {
    self.modifier(ADBackgroundViewModifier())
  }
  
  func addADBackgroundWithTrigger(
    _ curveTrigger: Binding<Bool>
  ) -> some View {
    self.modifier(ADBackgroundWithTriggerViewModifier(curveTrigger: curveTrigger))
  }
}

struct ADBackgroundViewModifier: ViewModifier {
  @State var curveTrigger = true
  
  func body(content: Content) -> some View {
    ZStack {
      ADBackground(curveTrigger: $curveTrigger)
      content
    }
  }
}

struct ADBackgroundWithTriggerViewModifier: ViewModifier {
  @Binding var curveTrigger: Bool
  
  func body(content: Content) -> some View {
    ZStack {
      ADBackground(curveTrigger: $curveTrigger)
      content
    }
  }
}

struct ADBackground: View {
  @Binding var curveTrigger: Bool
  
  var body: some View {
    ADUIKitResourcesAsset.Color.blue4.swiftUIColor
      .overlay {
        WaveView()
      }
      .mask {
        RandomCurve(curveTrigger: $curveTrigger)
      }
      .ignoresSafeArea()
  }
}

// MARK: - Preview

#Preview {
  Preview_ADBackground()
}

struct Preview_ADBackground: View {
  @State var curveTrigger = false
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      Button {
        curveTrigger.toggle()
      } label: {
        Text("ADBackground")
          .frame(width: 300, height: 300)
          .background(Color.green)
      }
    }
    .addADBackgroundWithTrigger($curveTrigger)
  }
}

