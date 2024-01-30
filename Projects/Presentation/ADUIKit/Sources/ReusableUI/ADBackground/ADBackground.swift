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
  func addADBackgroundWithStepBar() -> some View {
    self.modifier(ADBackgroundWithStepBarViewModifier())
  }
}

public extension View {
  func addADBackground() -> some View {
    self.modifier(ADBackgroundViewModifier())
  }
}

struct ADBackgroundWithStepBarViewModifier: ViewModifier {
  @State var randomCurvePoint: ADBackground.RandomCurvePoint = .init(rect: .zero)
  
  func body(content: Content) -> some View {
    ZStack {
      GeometryReader { geo in
        let rect: CGRect = geo.frame(in: .global)
        
        ADBackground(randomCurvePoint: $randomCurvePoint)
          .onAppear {
            self.randomCurvePoint = ADBackground.RandomCurvePoint(rect: rect)
          }
          .receiveShared(\.shared.stepBar.currentStep) { receivedValue in
            self.randomCurvePoint = ADBackground.RandomCurvePoint(rect: rect)
          }
      }
      
      content
    }
  }
}

struct ADBackgroundViewModifier: ViewModifier {
  @State var randomCurveTrigger = true
  @State var randomCurvePoint: ADBackground.RandomCurvePoint = .init(rect: .zero)
  
  func body(content: Content) -> some View {
    ZStack {
      GeometryReader { geo in
        let rect: CGRect = geo.frame(in: .global)
        
        ADBackground(randomCurvePoint: $randomCurvePoint)
          .onAppear {
            self.randomCurvePoint = ADBackground.RandomCurvePoint(rect: rect)
          }
          .onChange(of: randomCurveTrigger, perform: { _ in
            self.randomCurvePoint = ADBackground.RandomCurvePoint(rect: rect)
          })
      }
      
      content
    }
  }
}

struct ADBackground: View {
  @Binding var randomCurvePoint: ADBackground.RandomCurvePoint
  
  var body: some View {
    ADUIKitResourcesAsset.Color.blue4.swiftUIColor
      .overlay {
        WaveView()
      }
      .mask {
        ADBackground.RandomCurveShape(randomCurvePoint: randomCurvePoint)
      }
      .animation(.spring(), value: randomCurvePoint)
      .ignoresSafeArea()
  }
}

// MARK: - Preview

#Preview {
  Preview_ADBackground()
}

struct Preview_ADBackground: View {
  @State var randomCurveTrigger = false
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      Button {
        self.randomCurveTrigger.toggle()
      } label: {
        Text("ADBackground")
          .frame(width: 300, height: 300)
          .background(Color.green)
      }
    }
    .addADBackground()
  }
}

