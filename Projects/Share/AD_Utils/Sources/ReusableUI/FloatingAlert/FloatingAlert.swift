//
//  FloatingAlert.swift
//  AD_Utils
//
//  Created by minii on 2023/08/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct FloatingAlert: View {
  let text: String
  let color: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  @State var height: CGFloat = 0
  let textInset: CGFloat = 5
  
  public init(_ text: String) {
    self.text = text
  }
  
  public var body: some View {
    HStack(spacing: -textInset * 2) {
      Pointer()
        .fill(color)
        .frame(width: height, height: height)
      
      Text(text)
        .foregroundColor(.white)
        .padding(.all, textInset)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
        )
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                self.height = geo.size.height
              }
          }
        )
    }
  }
}

extension FloatingAlert {
  struct Pointer: Shape {
    let color: Color = ADUtilsAsset.Color.blue1.swiftUIColor
    
    func path(in rect: CGRect) -> Path {
      let width: CGFloat = rect.width
      let height: CGFloat = rect.height
      let insetX: CGFloat = -(rect.width / 10)
      let insetY: CGFloat = rect.height / 10
      
      return Path { path in
        path.move(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addCurve(
          to: CGPoint(x: width, y: 0),
          control1: CGPoint(x: insetX, y: rect.height - insetY),
          control2: CGPoint(x: insetX, y: insetY)
        )
      }
    }
  }
}

struct Previews_FloatingAlert: View {
  var body: some View {
    FloatingAlert("Tap CheckList!")
  }
}

struct FloatingAlert_Previews: PreviewProvider {
  static var previews: some View {
    Previews_FloatingAlert()
  }
}
