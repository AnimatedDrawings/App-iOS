//
//  ADBackground.swift
//  AD_UI
//
//  Created by minii on 2023/05/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

public struct ADBackground: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      let rect: CGRect = proxy.frame(in: .global)
      
      DoodleLines(rect: rect)
        .background(ADUtilsAsset.Color.blue4.swiftUIColor)
        .mask {
          RandomCurveShape().path(in: rect)
        }
    }
    .ignoresSafeArea()
  }
}

extension ADBackground {
  struct RandomCurveShape: Shape {
    func path(in rect: CGRect) -> Path {
      var path = Path()
      let start = CGPoint(x: 0, y: rect.midY)
      let end = CGPoint(x: rect.maxX, y: rect.midY / 2)
      let control1 = CGPoint(x: rect.maxX / 8, y: rect.midY / 6)
      let control2 = CGPoint(x: rect.maxX - (rect.maxX / 8), y: rect.midY - (rect.midY / 5))
      
      path.move(to: start)
      path.addCurve(to: end, control1: control1, control2: control2)
      
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: 0, y: rect.maxY))
      path.addLine(to: start)
      
      return path
    }
  }
}

struct ADBackground_Previews: PreviewProvider {
  static var previews: some View {
    ADBackground()
  }
}
