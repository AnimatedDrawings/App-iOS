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
      
      var leftStart: CGPoint = leftStartRandom(rect: rect)
      var rightEnd: CGPoint = rightEndRandom(rect: rect)
      let up: CGFloat = rect.maxY / 8
      leftStart.y -= up
      rightEnd.y -= up
      
      let leftControl: CGPoint = leftControlRandom(rect: rect, leftStart: leftStart)
      let rightControl: CGPoint = rightControlRandom(rect: rect, rightEnd: rightEnd)
      
      path.move(to: leftStart)
      path.addCurve(to: rightEnd, control1: leftControl, control2: rightControl)

      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: 0, y: rect.maxY))
      path.addLine(to: leftStart)
      
      return path
    }
    
    func leftStartRandom(rect: CGRect) -> CGPoint {
      let yInset: CGFloat = rect.maxY / 9
      let standY: CGFloat = rect.midY + 50
      let startRangeY: CGFloat = standY - yInset
      let endRangeY: CGFloat = standY + yInset
      let randomY = CGFloat.random(in: .safeRange(start: startRangeY, end: endRangeY))
      
      return CGPoint(x: 0, y: randomY)
    }
    
    func leftControlRandom(rect: CGRect, leftStart: CGPoint) -> CGPoint {
      let xInset: CGFloat = rect.maxX / 8
      let startRangeX: CGFloat = xInset
      let endRangeX: CGFloat = rect.midX - xInset
      let randomX = CGFloat.random(in: .safeRange(start: startRangeX, end: endRangeX))
      
      let yInset: CGFloat = rect.maxY / 12
      let startRangeY: CGFloat = yInset
      let endRangeY: CGFloat = leftStart.y - (yInset * 4)
      let randomY = CGFloat.random(in: .safeRange(start: startRangeY, end: endRangeY))
      
      return CGPoint(x: randomX, y: randomY)
    }
    
    func rightEndRandom(rect: CGRect) -> CGPoint {
      let yInset: CGFloat = rect.maxY / 6
      let startRangeY: CGFloat = yInset
      let endRangeY: CGFloat = yInset * 2
      let randomY = CGFloat.random(in: .safeRange(start: startRangeY, end: endRangeY))
      
      return CGPoint(x: rect.maxX, y: randomY)
    }
    
    func rightControlRandom(rect: CGRect, rightEnd: CGPoint) -> CGPoint {
      let xInset: CGFloat = rect.maxX / 8
      let startRangeX: CGFloat = xInset * 5
      let endRangeX: CGFloat = xInset * 7
      let randomX = CGFloat.random(in: .safeRange(start: startRangeX, end: endRangeX))
      
      let yInset: CGFloat = rect.maxY / 10
      let startRangeY: CGFloat = rightEnd.y + (yInset * 2)
      let endRangeY: CGFloat = rightEnd.y + (yInset * 4)
      let randomY = CGFloat.random(in: .safeRange(start: startRangeY, end: endRangeY))
      
      return CGPoint(x: randomX, y: randomY)
    }
  }
}

struct ADBackground_Previews: PreviewProvider {
  static var previews: some View {
    ADBackground()
  }
}
