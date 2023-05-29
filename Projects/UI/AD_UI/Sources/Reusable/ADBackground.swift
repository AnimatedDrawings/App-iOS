//
//  ADBackground.swift
//  AD_UI
//
//  Created by minii on 2023/05/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct ADBackground: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      let rect: CGRect = proxy.frame(in: .global)
      
      DoodleLines(verticalMaxY: rect.maxY)
    }
    .ignoresSafeArea()
  }
}

extension ADBackground {
  struct DoodleLines: View {
    let verticalMaxY: CGFloat
    let verticalCount: Int = 5
    
    var body: some View {
      ZStack {
        VerticalLines(
          maxY: verticalMaxY,
          separated: calLenSeparated(totalLen: verticalMaxY, count: verticalCount)
        )
        .stroke(lineWidth: 2)
      }
    }
    
    func calLenSeparated(
      totalLen: CGFloat,
      count: Int
    ) -> CGFloat {
      return trunc(totalLen / CGFloat(count))
    }
  }
}

extension ADBackground.DoodleLines {
  struct VerticalLines: Shape {
    let maxY: CGFloat
    let separated: CGFloat
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      
      drawVerticalLine(path: &path, fixX: rect.midX)
      
      return path
    }
    
    func drawVerticalLine(path: inout Path, fixX: CGFloat) {
      let verticalInset: CGFloat = separated / 5
      let horizontalMinInset: CGFloat = 5
      let horizontalMaxInset: CGFloat = 10
      var isLeft: Bool = .random()
      var start: CGPoint = .init(x: fixX, y: 0)
      
      for y in stride(from: separated, through: maxY, by: separated) {
        let curY = maxY < y + separated ? maxY : y
        let end = CGPoint(x: fixX, y: curY)
        let randomControlPoint: CGPoint = randomControlPoint(
          start: start,
          end: end,
          horizontalMinInset: horizontalMinInset,
          horizontalMaxInset: horizontalMaxInset,
          verticalInset: verticalInset,
          isLeft: isLeft
        )
        
        path.move(to: start)
        path.addQuadCurve(to: end, control: randomControlPoint)
        
        isLeft.toggle()
        start.y = end.y
      }
    }
    
    func randomControlPoint(
      start: CGPoint,
      end: CGPoint,
      horizontalMinInset: CGFloat,
      horizontalMaxInset: CGFloat,
      verticalInset: CGFloat,
      isLeft: Bool
    ) -> CGPoint {
      let randomX = randomHorizontalRange(
        fixX: start.x,
        isLeft: isLeft,
        horizontalMinInset: horizontalMinInset,
        horizontalMaxInset: horizontalMaxInset
      )
      let randomY = randomVerticalRange(
        startY: start.y,
        endY: end.y,
        verticalInset: verticalInset
      )
      
      return CGPoint(x: randomX, y: randomY)
    }
    
    func randomHorizontalRange(
      fixX: CGFloat,
      isLeft: Bool,
      horizontalMinInset: CGFloat,
      horizontalMaxInset: CGFloat
    ) -> CGFloat {
      let startRange: CGFloat = isLeft ? fixX - horizontalMaxInset : fixX + horizontalMaxInset
      let endRange: CGFloat = isLeft ? fixX - horizontalMinInset : fixX + horizontalMinInset
      let randomX: CGFloat = isLeft ? CGFloat.random(in: startRange...endRange) : CGFloat.random(in: endRange...startRange)
      
      return randomX
    }
    
    func randomVerticalRange(
      startY: CGFloat,
      endY: CGFloat,
      verticalInset: CGFloat
    ) -> CGFloat {
      let startRange: CGFloat = startY + verticalInset
      let endRange: CGFloat = endY - verticalInset
      
      return CGFloat.random(in: startRange...endRange)
    }
  }
}

struct ADBackground_Previews: PreviewProvider {
  static var previews: some View {
    ADBackground()
  }
}
