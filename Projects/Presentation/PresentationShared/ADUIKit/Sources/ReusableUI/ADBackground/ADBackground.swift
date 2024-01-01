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
  func addBackground() -> some View {
    self.background(ADBackground())
  }
}

struct ADBackground: View {
  @State var randomCurvePoint: RandomCurvePoint = .init(rect: .zero)
  
  var body: some View {
    GeometryReader { geo in
      let rect: CGRect = geo.frame(in: .global)

      ADUIKitResourcesAsset.Color.blue4.swiftUIColor
        .overlay {
          DoodleLines(rect: rect)
        }
        .mask {
          RandomCurveShape(randomCurvePoint: randomCurvePoint)
        }
        .receiveShared(\.shared.stepBar.currentStep) { receivedValue in
          self.randomCurvePoint = RandomCurvePoint(rect: rect)
        }
    }
    .ignoresSafeArea()
    .animation(.spring(), value: randomCurvePoint)
  }
}

#Preview {
  Preview_ADBackground()
}

struct Preview_ADBackground: View {
  var body: some View {
    VStack {
      Text("ADBackground")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .addBackground()
  }
}

