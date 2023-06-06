//
//  CropImageView.swift
//  AD_UI
//
//  Created by minii on 2023/06/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct CropImageView: View {
  let lineWidth: CGFloat = 3
  /// (lineWidth * lineCount) + (minimumSpace * spaceCount)
  let minSize: CGFloat = (3 * 4) + (2 * 3)
  @State var isTopOrLeft: Bool = false
  @State var isVertical: Bool = false
  @Binding var cropRect: CGRect
  
  let maxWidth: CGFloat
  let maxHeight: CGFloat
  @State var curX: CGFloat
  @State var curY: CGFloat
  @State var curWidth: CGFloat
  @State var curHeight: CGFloat
  
  init(initRect: CGRect, cropRect: Binding<CGRect>) {
    self._cropRect = cropRect
    
    self.maxWidth = initRect.size.width
    self.maxHeight = initRect.size.height
    self.curX = initRect.origin.x
    self.curY = initRect.origin.y
    self.curWidth = initRect.size.width
    self.curHeight = initRect.size.height
  }
  
  var body: some View {
    Rectangle()
      .frame(width: maxWidth, height: maxHeight)
      .foregroundColor(.gray.opacity(0.3))
      .overlay {
        CropView()
      }
  }
}

extension CropImageView {
  @ViewBuilder
  func CropView() -> some View {
    ZStack {
      CropStroke()
      CropCircles()
    }
  }
}

extension CropImageView {
  @ViewBuilder
  func CropStroke() -> some View {
    VStack {
      ZStack(alignment: .topLeading) {
        Rectangle()
          .stroke(ADUtilsAsset.Color.blue3.swiftUIColor, lineWidth: lineWidth)
      }
      .offset(
        x: curX,
        y: curY
      )
      .frame(maxWidth: curWidth, maxHeight: curHeight, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

extension CropImageView {
  @ViewBuilder
  func cropCircle(row: Int, col: Int) -> some View {
    Circle()
      .frame(width: 20, height: 20)
      .foregroundColor(.white)
      .overlay {
        Circle()
          .strokeBorder(ADUtilsAsset.Color.blue3.swiftUIColor, lineWidth: lineWidth)
      }
      .position(
        x: curX + ((curWidth / 2) * CGFloat(col)),
        y: curY + ((curHeight / 2) * CGFloat(row))
      )
  }
  
  @ViewBuilder
  func CropCircles() -> some View {
    ZStack {
      ForEach(0...2, id: \.self) { row in
        ForEach(0...2, id: \.self) { col in
          if !(row == 1 && col == 1) {
            if (row + col) % 2 == 0 {
              
            } else {
              let isVertical: Bool = col != 1 ? true : false
              let isTopOrLeft: Bool = row == 0 || col == 0 ? true : false
              
              cropCircle(row: row, col: col)
                .gesture(LineGesture(isVertical: isVertical, isTopOrLeft: isTopOrLeft))
            }
          }
        }
      }
    }
  }
}

extension CropImageView {
  func LineGesture(isVertical: Bool, isTopOrLeft: Bool) -> some Gesture {
    return DragGesture()
      .onChanged { value in
        gestureOnChangedAction(value: value, isVertical: isVertical, isTopOrLeft: isTopOrLeft)
      }
      .onEnded(gestureOnEndedAction)
  }
  
  func gestureOnChangedAction(
    value: DragGesture.Value,
    isVertical: Bool,
    isTopOrLeft: Bool
  ) {
    if self.isTopOrLeft != isTopOrLeft {
      self.isTopOrLeft = isTopOrLeft
    }
    
    if self.isVertical != isVertical {
      self.isVertical = isVertical
    }
    
    let tmpTranslation: CGFloat = isVertical ? value.translation.width : value.translation.height
    let translation: CGFloat = isTopOrLeft ? -tmpTranslation : tmpTranslation
    let lastSize: CGFloat = isVertical ? cropRect.width : cropRect.height
    let lastOrigin: CGFloat = isVertical ? cropRect.origin.x : cropRect.origin.y
    let maxSize: CGFloat = isVertical ? maxWidth : maxHeight
    let curSize: CGFloat = isVertical ? curWidth : curHeight
    let tmpSize: CGFloat = currentSize(
      translation: translation,
      lastSize: lastSize,
      lastOrigin: lastOrigin,
      maxSize: maxSize
    )
    
    if tmpSize != curSize {
      if isVertical {
        curWidth = tmpSize
        if isTopOrLeft {
          curX = lastOrigin - translation
        }
      } else {
        curHeight = tmpSize
        if isTopOrLeft {
          curY = lastOrigin - translation
        }
      }
    }
  }
  
  func gestureOnEndedAction(_ value: DragGesture.Value) {
    if self.isVertical {
      cropRect.size.width = curWidth
      cropRect.origin.x = curX
    } else {
      cropRect.size.height = curHeight
      cropRect.origin.y = curY
    }
  }
}

extension CropImageView {
  func curSpace(_ curSize: CGFloat) -> CGFloat {
    /// (curSize(width or height) - totalLineWidth) / spaceCount
    return CGFloat((curSize - 12) / 3)
  }
  
  func currentSize(
    translation: CGFloat,
    lastSize: CGFloat,
    lastOrigin: CGFloat,
    maxSize: CGFloat
  ) -> CGFloat {
    let curSize: CGFloat = lastSize + translation
    let tmpMaxSize: CGFloat = self.isTopOrLeft ? lastSize + lastOrigin : maxSize - lastOrigin
    
    return max(minSize, min(tmpMaxSize, curSize))
  }
}

public struct TestViewFinder: View {
  
  public init() {}
  
  public var body: some View {
    ViewFinder()
  }
}

struct CropImageView_Previews: PreviewProvider {
  static var previews: some View {
    TestViewFinder()
  }
}
