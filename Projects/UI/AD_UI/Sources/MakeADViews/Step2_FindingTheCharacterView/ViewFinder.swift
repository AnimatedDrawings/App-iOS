//
//  ViewFinder.swift
//  AD_UI
//
//  Created by minii on 2023/06/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct ViewFinder: View {
  let lineWidth: CGFloat = 3
  /// (lineWidth * lineCount) + (minimumSpace * spaceCount)
  let minSize: CGFloat = (3 * 4) + (2 * 3)
  @State var isTopOrLeft: Bool = false
  @State var isVertical: Bool = false
  @State var cropRect: CGRect
  
  let maxWidth: CGFloat
  let maxHeight: CGFloat
  @State var curX: CGFloat
  @State var curY: CGFloat
  @State var curWidth: CGFloat
  @State var curHeight: CGFloat
  
  init(width: CGFloat = 300, height: CGFloat = 400) {
    self.cropRect = .init(origin: .zero, size: .init(width: width, height: height))
    
    self.maxWidth = width
    self.maxHeight = height
    self.curX = 0
    self.curY = 0
    self.curWidth = width
    self.curHeight = height
  }
  
  var body: some View {
    Rectangle()
      .frame(width: maxWidth, height: maxHeight)
      .foregroundColor(.gray.opacity(0.3))
      .overlay {
        CropStroke()
      }
      .overlay {
        CropCircles()
      }
      .onChange(of: curX) { newValue in
        print("curX : \(curX)")
      }
      .onChange(of: curY) { newValue in
        print("curY : \(curY)")
      }
      .onChange(of: curWidth) { newValue in
        print("curWidth : \(curWidth)")
      }
      .onChange(of: curHeight) { newValue in
        print("curHeight : \(curHeight)")
        print("")
      }
  }
}

extension ViewFinder {
  @ViewBuilder
  func CropStroke() -> some View {
    Rectangle()
      .stroke(ADUtilsAsset.Color.blue3.swiftUIColor, lineWidth: lineWidth)
//      .position(x: (maxWidth / 2) - curX, y: (maxHeight / 2) - curY)
//      .position(x: 0, y: 0)
      .frame(width: curWidth, height: curHeight)
//      .offset(x: curX, y: curY)
//      .position(x: curX + (curWidth / 2), y: curY + (curHeight / 2))
//      .position(x : (curWidth / 2), y: (curHeight / 2))
  }
}

extension ViewFinder {
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

extension ViewFinder {
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

extension ViewFinder {
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
