//
//  RandomCurveShape.swift
//  AD_UI
//
//  Created by minii on 2023/06/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension ADBackground {
  struct RandomCurveShape: Shape {
    var leftStart: CGPoint
    var rightEnd: CGPoint
    var leftControl: CGPoint
    var rightControl: CGPoint
    
    var animatableData: RandomCurveAnimatabledata {
      get {
        RandomCurveAnimatabledata(
          leftStart: leftStart,
          rightEnd: rightEnd,
          leftControl: leftControl,
          rightControl: rightControl
        )
      }
      set {
        leftStart = newValue.leftStart
        rightEnd = newValue.rightEnd
        leftControl = newValue.leftControl
        rightControl = newValue.rightControl
      }
    }

    init(randomCurvePoint: RandomCurvePoint) {
      self.leftStart = randomCurvePoint.leftStart
      self.rightEnd = randomCurvePoint.rightEnd
      self.leftControl = randomCurvePoint.leftControl
      self.rightControl = randomCurvePoint.rightControl
      self.animatableData = RandomCurveAnimatabledata(
        leftStart: randomCurvePoint.leftStart,
        rightEnd: randomCurvePoint.rightEnd,
        leftControl: randomCurvePoint.leftControl,
        rightControl: randomCurvePoint.rightControl
      )
    }
    
    func path(in rect: CGRect) -> Path {
      var path = Path()

      let leftDown = CGPoint(x: 0, y: rect.maxY)
      let rightDown = CGPoint(x: rect.maxX, y: rect.maxY)

      path.move(to: leftStart)
      path.addCurve(
        to: rightEnd,
        control1: leftControl,
        control2: rightControl
      )

      path.addLine(to: rightDown)
      path.addLine(to: leftDown)
      path.addLine(to: leftStart)

      return path
    }
  }
}
