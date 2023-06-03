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
  
  let maxWidth: CGFloat
  @State var lastWidth: CGFloat
  @State var curWidth: CGFloat
  
  let maxHeight: CGFloat
  @State var lastHeight: CGFloat
  @State var curHeight: CGFloat
  
  init(width: CGFloat = 300, height: CGFloat = 400) {
    self.maxWidth = width
    self.lastWidth = width
    self.curWidth = width
    
    self.maxHeight = height
    self.lastHeight = height
    self.curHeight = height
  }
  
  var body: some View {
    Rectangle()
      .frame(width: maxWidth, height: maxHeight)
      .foregroundColor(.cyan)
      .overlay {
        TestGridView()
      }
  }
}

extension ViewFinder {
  @ViewBuilder
  func GridView() -> some View {
    VStack {
      ZStack(alignment: .topLeading) {
        VerticalLines(curSpace(curWidth))
        HorizontalLines(curSpace(curHeight))
      }
      .frame(maxWidth: curWidth, maxHeight: curHeight, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
  
  @ViewBuilder
  func TestGridView() -> some View {
    VStack {
      ZStack(alignment: .topLeading) {
        VerticalLines(curSpace(curWidth))
        HorizontalLines(curSpace(curHeight))
      }
      .frame(maxWidth: curWidth, maxHeight: curHeight, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
    maxSize: CGFloat
  ) -> CGFloat {
    return max(minSize, min(maxSize, lastSize + translation))
  }
}

extension ViewFinder {
  func GridGesture(
    isVertical: Bool,
    isTopOrLeft: Bool
  ) -> some Gesture {
    return DragGesture()
      .onChanged { value in
        let tmpTranslation: CGFloat = isVertical ? value.translation.width : value.translation.height
        let translation: CGFloat = isTopOrLeft ? -tmpTranslation : tmpTranslation
        let lastSize: CGFloat = isVertical ? lastWidth : lastHeight
        let maxSize: CGFloat = isVertical ? maxWidth : maxHeight
        let curSize: CGFloat = isVertical ? curWidth : curHeight
        
        if self.isTopOrLeft != isTopOrLeft {
          self.isTopOrLeft = isTopOrLeft
        }
        
        let tmpSize = currentSize(
          translation: translation,
          lastSize: lastSize,
          maxSize: maxSize
        )
        if tmpSize != curSize {
          if isVertical {
            curWidth = tmpSize
          } else {
            curHeight = tmpSize
          }
        }
      }
      .onEnded { _ in
        if isVertical {
          lastWidth = curWidth
        } else {
          lastHeight = curHeight
        }
      }
  }
}

extension ViewFinder {
  var verticalLine: some View {
    Rectangle()
      .frame(maxHeight: .infinity)
      .frame(width: lineWidth)
  }
  
  @ViewBuilder
  func VerticalLines(_ curSpace: CGFloat) -> some View {
    ZStack {
      verticalLine
        .gesture(GridGesture(isVertical: true, isTopOrLeft: true))
      verticalLine
        .offset(x: lineWidth)
        .offset(x: curSpace)
      verticalLine
        .offset(x: lineWidth * 2)
        .offset(x: curSpace * 2)
      verticalLine
        .offset(x: lineWidth * 3)
        .offset(x: curSpace * 3)
        .gesture(GridGesture(isVertical: true, isTopOrLeft: false))
    }
  }
}

extension ViewFinder {
  var horizontalLine: some View {
    Rectangle()
      .frame(maxWidth: .infinity)
      .frame(height: lineWidth)
  }
  
  @ViewBuilder
  func HorizontalLines(_ curSpace: CGFloat) -> some View {
    ZStack {
      horizontalLine
        .gesture(GridGesture(isVertical: false, isTopOrLeft: true))
      horizontalLine
        .offset(y: lineWidth)
        .offset(y: curSpace)
      horizontalLine
        .offset(y: lineWidth * 2)
        .offset(y: curSpace * 2)
      horizontalLine
        .offset(y: lineWidth * 3)
        .offset(y: curSpace * 3)
        .gesture(GridGesture(isVertical: false, isTopOrLeft: false))
    }
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
