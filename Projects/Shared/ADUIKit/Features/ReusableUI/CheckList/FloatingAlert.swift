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
  let backgroundColor: Color
  
  public init(
    text: String,
    color: Color
  ) {
    self.text = text
    self.backgroundColor = color
  }
  
  @State var width: CGFloat = 0
  @State var height: CGFloat = 0
  let textInset: CGFloat = 5
  
  @State var dist: CGFloat = 0
  
  public var body: some View {
    ZStack(alignment: .trailing) {
      MyBackground(inset: textInset)
        .fill(backgroundColor)
        .frame(width: self.width, height: self.height)
      
      Text(text)
        .foregroundColor(.white)
        .font(.caption)
        .padding([.top, .trailing, .bottom], textInset)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                self.width = geo.size.width + geo.size.height
                self.height = geo.size.height
                self.dist = geo.size.height / 4
              }
          }
        )
    }
    .addFloatingAnimation(dist: $dist)
  }
}

extension FloatingAlert {
  struct MyBackground: Shape {
    let inset: CGFloat
    
    init(inset: CGFloat) {
      self.inset = inset * 2
    }
    
    func path(in rect: CGRect) -> Path {
      let width: CGFloat = rect.width
      let height: CGFloat = rect.height
      let startX: CGFloat = rect.height
      let controlY: CGFloat = rect.height / 8
      
      return Path { path in
        path.move(to: CGPoint(x: startX, y: 0))
        path.addLine(to: CGPoint(x: width - inset, y: 0))
        path.addQuadCurve(
          to: CGPoint(x: width, y: inset),
          control: CGPoint(x: width, y: 0)
        )
        path.addLine(to: CGPoint(x: width, y: height - inset))
        path.addQuadCurve(
          to: CGPoint(x: width - inset, y: height),
          control: CGPoint(x: width, y: height)
        )
        path.addLine(to: CGPoint(x: startX, y: height))
        path.addCurve(
          to: CGPoint(x: startX, y: 0),
          control1: CGPoint(x: 0, y: height - controlY),
          control2: CGPoint(x: 0, y: controlY)
        )
      }
    }
  }
}
