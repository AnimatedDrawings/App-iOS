//
//  CropCircles.swift
//  CropImage
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct CropCircles: View {
  @Binding var viewBoundingBox: CGRect
  @Binding var viewSize: CGSize
  let strokeColor: Color
  let lineWidth: CGFloat
  
  @State var curRect: CGRect = .init()
  @State var lastRect: CGRect = .init()
  let circleCount: Int
  let circleSize: CGFloat
  let minSize: CGFloat
  
  init(
    viewBoundingBox: Binding<CGRect>,
    viewSize: Binding<CGSize>,
    strokeColor: Color,
    lineWidth: CGFloat
  ) {
    self._viewBoundingBox = viewBoundingBox
    self._viewSize = viewSize
    self.strokeColor = strokeColor
    self.lineWidth = lineWidth
    
    self._curRect = State(initialValue: viewBoundingBox.wrappedValue)
    self._lastRect = State(initialValue: viewBoundingBox.wrappedValue)
    self.circleCount = 3
    self.circleSize = 20
    let totalCircleSize: CGFloat = circleSize * CGFloat(circleCount - 1)
    let minimumSpace: CGFloat = 5
    let spaceSize: CGFloat = minimumSpace * CGFloat(circleCount - 1)
    self.minSize = totalCircleSize + spaceSize
  }
  
  var body: some View {
    ZStack {
      ForEach(0...(circleCount - 1), id: \.self) { row in
        ForEach(0...(circleCount - 1), id: \.self) { col in
          if edgeIndex(row: row, col: col) {
            if pointIndex(row: row, col: col) {
              CropCircle(row: row, col: col)
                .gesture(pointGesture(row: row, col: col))
            } else {
              CropCircle(row: row, col: col)
                .gesture(lineGesture(row: row, col: col))
            }
          }
        }
      }
    }
    .onChange(of: viewBoundingBox, perform: updateBoundingBox)
  }
  
  func edgeIndex(row: Int, col: Int) -> Bool {
    return !(0 < row && row < circleCount - 1) || !(0 < col && col < circleCount - 1)
  }
  
  func pointIndex(row: Int, col: Int) -> Bool {
    return (row + col) % (circleCount - 1) == 0
  }
  
  func updateBoundingBox(_: CGRect) {
    self.curRect = viewBoundingBox
    self.lastRect = viewBoundingBox
  }
}

extension CropCircles {
  func CropCircle(row: Int, col: Int) -> some View {
    Circle()
      .frame(width: circleSize, height: circleSize)
      .foregroundColor(.white)
      .overlay {
        Circle()
          .strokeBorder(strokeColor, lineWidth: lineWidth)
      }
      .position(cropCirclePosition(row: row, col: col))
  }
  
  func cropCirclePosition(row: Int, col: Int) -> CGPoint {
    CGPoint(
      x: curRect.minX + ((curRect.width / CGFloat(circleCount - 1)) * CGFloat(col)),
      y: curRect.minY + ((curRect.height / CGFloat(circleCount - 1)) * CGFloat(row))
    )
  }
}

extension CropCircles {
  func pointGesture(row: Int, col: Int) -> some Gesture {
    let firstGesture: AnyGesture = row == 0 ?
    AnyGesture(topGesture().map { _ in ()}) :
    AnyGesture(bottomGesture().map { _ in ()})
    
    let secondGesture: AnyGesture = col == 0 ?
    AnyGesture(leftGesture().map { _ in ()}) :
    AnyGesture(rightGesture().map { _ in ()})
    
    return firstGesture.simultaneously(with: secondGesture)
  }
  
  func lineGesture(row: Int, col: Int) -> some Gesture {
    if row == 0 {
      return AnyGesture(topGesture().map { _ in () })
    }
    else if col == 0 {
      return AnyGesture(leftGesture().map { _ in () })
    }
    else if row == (circleCount - 1) {
      return AnyGesture(bottomGesture().map { _ in () })
    }
    return AnyGesture(rightGesture().map { _ in () })
  }
  
  func topGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        let nexHeight: CGFloat = lastRect.height + (-value.translation.height)
        guard minSize < nexHeight else {
          return
        }
        
        guard nexHeight < lastRect.minY + lastRect.height else {
          return
        }
        
        curRect.size.height = nexHeight
        curRect.origin.y = lastRect.minY + value.translation.height
      }
      .onEnded { value in
        lastRect.size.height = curRect.height
        lastRect.origin.y = curRect.minY
      }
  }
  
  func bottomGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        let nexHeight: CGFloat = lastRect.height + value.translation.height
        guard minSize < nexHeight else {
          return
        }
        
        guard nexHeight < viewSize.height - lastRect.minY else {
          return
        }
        
        curRect.size.height = nexHeight
      }
      .onEnded { value in
        lastRect.size.height = curRect.height
      }
  }
  
  func leftGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        let nexWidth: CGFloat = lastRect.width + (-value.translation.width)
        guard minSize < nexWidth else {
          return
        }
        
        guard nexWidth < lastRect.minX + lastRect.width else {
          return
        }
        
        curRect.origin.x = lastRect.minX + value.translation.width
        curRect.size.width = nexWidth
      }
      .onEnded { value in
        lastRect.origin.x = curRect.minX
        lastRect.size.width = curRect.width
      }
  }
  
  func rightGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        let nexWidth: CGFloat = lastRect.width + value.translation.width
        guard minSize < nexWidth else {
          return
        }
        
        guard nexWidth < viewSize.width - lastRect.minX else {
          return
        }
        
        curRect.size.width = nexWidth
      }
      .onEnded { value in
        lastRect.size.width = curRect.width
      }
  }
}
