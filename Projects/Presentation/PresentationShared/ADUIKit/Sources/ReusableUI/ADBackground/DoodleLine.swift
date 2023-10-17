//
//  DoodleLine.swift
//  AD_UI
//
//  Created by minii on 2023/05/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension ADBackground {
  struct DoodleLines: View {
    let rect: CGRect
    let verticalCount: Int = 3
    let horizontalCount: Int = 6
    
    var body: some View {
      ZStack {
        VerticalLines(
          separated: calLenSeparated(totalLen: rect.maxY, count: verticalCount)
        )
        .stroke(lineWidth: 2)
        
        HorizontalLines(
          separated: calLenSeparated(totalLen: rect.maxX, count: horizontalCount)
        )
        .stroke(lineWidth: 2)
      }
      .foregroundColor(.gray.opacity(0.3))
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
    let separated: CGFloat

    func path(in rect: CGRect) -> Path {
      var path = Path()
      let padding: CGFloat = 5

      for fixX in stride(from: -padding, through: rect.maxX + padding, by: 30) {
        drawVerticalLine(path: &path, fixX: fixX, maxY: rect.maxY)
      }

      return path
    }

    func drawVerticalLine(path: inout Path, fixX: CGFloat, maxY: CGFloat) {
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

//        path.addEllipse(in: .init(origin: randomControlPoint, size: .init(width: 10, height: 10)))

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
  
  struct HorizontalLines: Shape {
    let separated: CGFloat
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      let padding: CGFloat = 5
      
      for fixY in stride(from: -padding, through: rect.maxY + padding, by: 30) {
        drawHorizontalLine(path: &path, fixY: fixY, maxX: rect.maxX)
      }
      
      return path
    }
    
    func drawHorizontalLine(path: inout Path, fixY: CGFloat, maxX: CGFloat) {
      let horizontalInset: CGFloat = separated / 3
      let verticalMinInset: CGFloat = 1
      let verticalMaxInset: CGFloat = 3
      var isTop: Bool = .random()
      var start: CGPoint = .init(x: 0, y: fixY)
      
      for x in stride(from: separated, through: maxX, by: separated) {
        let curX = maxX < x + separated ? maxX : x
        let end = CGPoint(x: curX, y: fixY)
        
        let randomControlPoint = randomControlPoint(
          start: start,
          end: end,
          verticalMinInset: verticalMinInset,
          verticalMaxInset: verticalMaxInset,
          horizontalInset: horizontalInset,
          isTop: isTop
        )
        
        path.move(to: start)
        path.addQuadCurve(to: end, control: randomControlPoint)
        
        isTop.toggle()
        start.x = end.x
      }
    }
    
    func randomControlPoint(
      start: CGPoint,
      end: CGPoint,
      verticalMinInset: CGFloat,
      verticalMaxInset: CGFloat,
      horizontalInset: CGFloat,
      isTop: Bool
    ) -> CGPoint {
      let randomX = randomHorizontalRange(
        startX: start.x,
        endX: end.x,
        horizontalInset: horizontalInset
      )
      
      let randomY = randomVerticalRange(
        fixY: start.y,
        isTop: isTop,
        verticalMinInset: verticalMinInset,
        verticalMaxInset: verticalMaxInset
      )
      
      return CGPoint(x: randomX, y: randomY)
    }
    
    func randomVerticalRange(
      fixY: CGFloat,
      isTop: Bool,
      verticalMinInset: CGFloat,
      verticalMaxInset: CGFloat
    ) -> CGFloat {
      let startRange: CGFloat = isTop ? fixY - verticalMaxInset : fixY + verticalMaxInset
      let endRange: CGFloat = isTop ? fixY - verticalMinInset : fixY + verticalMinInset
      let randomX: CGFloat = isTop ? CGFloat.random(in: startRange...endRange) : CGFloat.random(in: endRange...startRange)
      
      return randomX
    }
    
    func randomHorizontalRange(
      startX: CGFloat,
      endX: CGFloat,
      horizontalInset: CGFloat
    ) -> CGFloat {
      let startRange: CGFloat = startX + horizontalInset
      let endRange: CGFloat = endX - horizontalInset
      
      return CGFloat.random(in: startRange...endRange)
    }
  }
}
