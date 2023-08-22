//
//  ADBackground.swift
//  AD_UI
//
//  Created by minii on 2023/05/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

/// Use
public extension View {
  func adBackground() -> some View {
    self.background(ADBackground())
  }
}

struct ADBackground: View {
  var body: some View {
    GeometryReader { geo in
      let rect: CGRect = geo.frame(in: .global)

      ADUtilsAsset.Color.blue4.swiftUIColor
        .overlay {
          DoodleLines(rect: rect)
        }
        .mask {
          RandomCurveShape().path(in: rect)
            .if(.random()) {
              $0
            } else: {
              $0.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
    .ignoresSafeArea()
       
  }
}

struct PreviewsADBackground: View {
  var body: some View {
    GeometryReader { geo in
      ScrollView {
        VStack(spacing: 50) {
          ForEach(1...30, id: \.self) { index in
            Rectangle()
              .frame(width: 200, height: 200)
              .foregroundColor(.red)
          }
        }
        .frame(maxWidth: .infinity)
      }
      .background(ADBackground())
    }
  }
}

struct ADBackground_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsADBackground()
  }
}
