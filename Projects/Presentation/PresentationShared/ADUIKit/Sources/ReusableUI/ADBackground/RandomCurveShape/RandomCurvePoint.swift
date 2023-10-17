//
//  RandomCurvePoint.swift
//  ADUIKit
//
//  Created by minii on 2023/10/17.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

extension CGPoint {
  func changeY(to yPoint: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: yPoint)
  }
}

extension ADBackground {
  struct RandomCurvePoint: Equatable {
    let leftStart: CGPoint
    let rightEnd: CGPoint
    let leftControl: CGPoint
    let rightControl: CGPoint
    
    init(
      leftStart: CGPoint,
      rightEnd: CGPoint,
      leftControl: CGPoint,
      rightControl: CGPoint
    ) {
      self.leftStart = leftStart
      self.rightEnd = rightEnd
      self.leftControl = leftControl
      self.rightControl = rightControl
    }
    
    init(rect: CGRect, upRatio: CGFloat = 8) {
      let up: CGFloat = rect.maxY / upRatio
      var tmpLeftStart: CGPoint = Self.leftStartRandom(rect: rect)
      tmpLeftStart.y -= up
      var tmpRightEnd: CGPoint = Self.rightEndRandom(rect: rect)
      tmpRightEnd.y -= up

      let tmpLeftControl: CGPoint = Self.leftControlRandom(rect: rect, leftStart: tmpLeftStart)
      let tmpRightControl: CGPoint = Self.rightControlRandom(rect: rect, rightEnd: tmpRightEnd)
      
      let random = Bool.random()
      
      self.leftStart = random ? tmpLeftStart : tmpLeftStart.changeY(to: tmpRightEnd.y)
      self.rightEnd = random ? tmpRightEnd : tmpRightEnd.changeY(to: tmpLeftStart.y)
      self.leftControl = random ? tmpLeftControl : tmpLeftControl.changeY(to: tmpRightControl.y)
      self.rightControl = random ? tmpRightControl : tmpRightEnd.changeY(to: tmpLeftControl.y)
    }
    
    static func leftStartRandom(rect: CGRect) -> CGPoint {
      let yInset: CGFloat = rect.maxY / 9
      let standY: CGFloat = rect.midY + 50
      let startRangeY: CGFloat = standY - yInset
      let endRangeY: CGFloat = standY + yInset
      let randomY = CGFloat.random(in: .safeRange(start: startRangeY, end: endRangeY))
      
      return CGPoint(x: 0, y: randomY)
    }
    
    static func leftControlRandom(rect: CGRect, leftStart: CGPoint) -> CGPoint {
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
    
    static func rightEndRandom(rect: CGRect) -> CGPoint {
      let yInset: CGFloat = rect.maxY / 6
      let startRangeY: CGFloat = yInset
      let endRangeY: CGFloat = yInset * 2
      let randomY = CGFloat.random(in: .safeRange(start: startRangeY, end: endRangeY))
      
      return CGPoint(x: rect.maxX, y: randomY)
    }
    
    static func rightControlRandom(rect: CGRect, rightEnd: CGPoint) -> CGPoint {
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
