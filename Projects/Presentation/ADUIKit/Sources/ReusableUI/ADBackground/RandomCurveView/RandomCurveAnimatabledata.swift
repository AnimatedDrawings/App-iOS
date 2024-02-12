//
//  RandomCurveAnimatabledata.swift
//  ADUIKit
//
//  Created by minii on 2023/10/17.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import SwiftUI

extension CGPoint {
  func plus(with otherPoint: CGPoint) -> CGPoint {
    return CGPoint(x: self.x + otherPoint.x, y: self.y + otherPoint.y)
  }
  
  func minus(with otherPoint: CGPoint) -> CGPoint {
    return CGPoint(x: self.x - otherPoint.x, y: self.y - otherPoint.y)
  }
}

struct RandomCurveAnimatabledata: VectorArithmetic {
  static func -= (lhs: inout RandomCurveAnimatabledata, rhs: RandomCurveAnimatabledata) {
    lhs = lhs - rhs
  }
  
  static func += (lhs: inout RandomCurveAnimatabledata, rhs: RandomCurveAnimatabledata) {
    lhs = lhs + rhs
  }
  
  static func - (lhs: RandomCurveAnimatabledata, rhs: RandomCurveAnimatabledata) -> RandomCurveAnimatabledata {
    let tmpLeftStart = lhs.leftStart.minus(with: rhs.leftStart)
    let tmpRightEnd = lhs.rightEnd.minus(with: rhs.rightEnd)
    let tmpLeftControl = lhs.leftControl.minus(with: rhs.leftControl)
    let tmpRightControl = lhs.rightControl.minus(with: rhs.rightControl)
    
    return RandomCurveAnimatabledata(
      leftStart: tmpLeftStart,
      rightEnd: tmpRightEnd,
      leftControl: tmpLeftControl,
      rightControl: tmpRightControl
    )
  }
  
  static func + (lhs: RandomCurveAnimatabledata, rhs: RandomCurveAnimatabledata) -> RandomCurveAnimatabledata {
    let tmpLeftStart = lhs.leftStart.plus(with: rhs.leftStart)
    let tmpRightEnd = lhs.rightEnd.plus(with: rhs.rightEnd)
    let tmpLeftControl = lhs.leftControl.plus(with: rhs.leftControl)
    let tmpRightControl = lhs.rightControl.plus(with: rhs.rightControl)
    
    return RandomCurveAnimatabledata(
      leftStart: tmpLeftStart,
      rightEnd: tmpRightEnd,
      leftControl: tmpLeftControl,
      rightControl: tmpRightControl
    )
  }
  
  var length: Double {
    return Double(((rightEnd.x - leftStart.x) * (rightEnd.x - leftStart.x)) +
                  ((rightEnd.y - leftStart.y) * (rightEnd.y - leftStart.y))).squareRoot()
  }
  
  static var zero: RandomCurveAnimatabledata {
    return .init(
      leftStart: .zero,
      rightEnd: .zero,
      leftControl: .zero,
      rightControl: .zero
    )
  }
  
  var leftStart: CGPoint
  var rightEnd: CGPoint
  var leftControl: CGPoint
  var rightControl: CGPoint
  
  mutating func scale(by rhs: Double) {
    self.leftStart.x.scale(by: rhs)
    self.leftStart.y.scale(by: rhs)
    self.rightEnd.x.scale(by: rhs)
    self.rightEnd.y.scale(by: rhs)
    self.leftControl.x.scale(by: rhs)
    self.leftControl.y.scale(by: rhs)
    self.rightControl.x.scale(by: rhs)
    self.rightControl.y.scale(by: rhs)
  }
  
  var magnitudeSquared: Double {
    length * length
  }
}
