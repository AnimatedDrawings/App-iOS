//
//  GridView.swift
//  AD_UI
//
//  Created by minii on 2023/06/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitResources

import ThirdPartyLib
import CropImageFeatures

struct GridView: View {
  let strokeColor: Color = ADUIKitResourcesAsset.Color.blue3.swiftUIColor
  let lineWidth: CGFloat = 3
  /// (lineWidth * lineCount) + (minimumSpace * spaceCount)
  let minSize: CGFloat = (3 * 4) + (2 * 3)
  
  @Binding var croppedRect: CGRect
  @Binding var curX: CGFloat
  @Binding var curY: CGFloat
  @Binding var curWidth: CGFloat
  @Binding var curHeight: CGFloat
  
  let maxWidth: CGFloat
  let maxHeight: CGFloat
  
  @MainActor
  init(cropImageViewStore: ViewStoreOf<CropImageFeature>) {
    self._croppedRect = cropImageViewStore.$boundingBoxInfo.croppedRect
    self._curX = cropImageViewStore.$boundingBoxInfo.curRect.origin.x
    self._curY = cropImageViewStore.$boundingBoxInfo.curRect.origin.y
    self._curWidth = cropImageViewStore.$boundingBoxInfo.curRect.size.width
    self._curHeight = cropImageViewStore.$boundingBoxInfo.curRect.size.height
    self.maxWidth = cropImageViewStore.boundingBoxInfo.viewSize.width
    self.maxHeight = cropImageViewStore.boundingBoxInfo.viewSize.height
  }

  var body: some View {
    CropView()
  }
}

extension GridView {
  @ViewBuilder
  func CropView() -> some View {
    ZStack {
      CropStroke()
      CropCircles()
    }
    .contentShape(Rectangle())
    .gesture(DragGridGesture())
  }
}

extension GridView {
  @ViewBuilder
  func CropStroke() -> some View {
    VStack {
      ZStack(alignment: .topLeading) {
        Rectangle()
          .stroke(strokeColor, lineWidth: lineWidth)
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

extension GridView {
  @ViewBuilder
  func cropCircle(row: Int, col: Int) -> some View {
    Circle()
      .frame(width: 20, height: 20)
      .foregroundColor(.white)
      .overlay {
        Circle()
          .strokeBorder(strokeColor, lineWidth: lineWidth)
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
              let lines: [Line] = checkPoint(row: row, col: col)
              
              cropCircle(row: row, col: col)
                .gesture(PointGesture(lines))
            } else {
              let line: Line = checkLine(row: row, col: col)
              
              cropCircle(row: row, col: col)
                .gesture(LineGesture(line))
            }
          }
        }
      }
    }
  }
  
  func checkLine(row: Int, col: Int) -> Line {
    var tmpLine: Line = .top
    
    if row == 0 {
      tmpLine = .top
    }
    else if row == 2 {
      tmpLine = .bottom
    }
    if col == 0 {
      tmpLine = .left
    }
    else if col == 2 {
      tmpLine = .right
    }
    
    return tmpLine
  }
  
  func checkPoint(row: Int, col: Int) -> [Line] {
    let topOrBottom: Line = row == 0 ? .top : .bottom
    let leftOrRight: Line = col == 0 ? .left : .right
    
    return [topOrBottom, leftOrRight]
  }
}

extension GridView {
  func DragGridGesture() -> some Gesture {
    return DragGesture()
      .onChanged { value in
        let curOriginX: CGFloat = croppedRect.origin.x + value.translation.width
        let curOriginY: CGFloat = croppedRect.origin.y + value.translation.height
        let tmpOriginX: CGFloat = currentOrigin(
          curOrigin: curOriginX,
          maxSize: maxWidth,
          lastSize: croppedRect.size.width
        )
        let tmpOriginY: CGFloat = currentOrigin(
          curOrigin: curOriginY,
          maxSize: maxHeight,
          lastSize: croppedRect.size.height
        )
        
        if tmpOriginX != curX {
          curX = tmpOriginX
        }
        if tmpOriginY != curY {
          curY = tmpOriginY
        }
      }
      .onEnded { value in
        croppedRect.origin.x = curX
        croppedRect.origin.y = curY
      }
  }

  func currentOrigin(
    curOrigin: CGFloat,
    maxSize: CGFloat,
    lastSize: CGFloat
  ) -> CGFloat {
    let tmpMaxOrigin: CGFloat = maxSize - lastSize
    return max(0, min(curOrigin, tmpMaxOrigin))
  }
}

extension GridView {
  func LineGesture(_ line: Line) -> some Gesture {
    return DragGesture()
      .onChanged { value in
        gestureOnChangedAction(line: line, value: value)
      }
      .onEnded { value in
        gestureOnEndedAction(line: line, value: value)
      }
  }
  
  func PointGesture(_ lines: [Line]) -> some Gesture {
    return DragGesture()
      .onChanged { value in
        lines.forEach { line in
          gestureOnChangedAction(line: line, value: value)
        }
      }
      .onEnded { value in
        lines.forEach { line in
          gestureOnEndedAction(line: line, value: value)
        }
      }
  }
}

extension GridView {
  func gestureOnChangedAction(
    line: Line,
    value: DragGesture.Value
  ) {
    let isTopOrLeft: Bool = line.isTopOrLeft
    let isVertical: Bool = line.isVertical
    
    let tmpTranslation: CGFloat = isVertical ? value.translation.width : value.translation.height
    let translation: CGFloat = isTopOrLeft ? -tmpTranslation : tmpTranslation
    let lastSize: CGFloat = isVertical ? croppedRect.width : croppedRect.height
    let lastOrigin: CGFloat = isVertical ? croppedRect.origin.x : croppedRect.origin.y
    let maxSize: CGFloat = isVertical ? maxWidth : maxHeight
    let curSize: CGFloat = isVertical ? curWidth : curHeight
    let tmpSize: CGFloat = currentSize(
      translation: translation,
      lastSize: lastSize,
      lastOrigin: lastOrigin,
      maxSize: maxSize,
      isTopOrLeft: isTopOrLeft
    )
    
    if tmpSize != curSize {
      if isVertical {
        curWidth = tmpSize
        if isTopOrLeft {
          curX = lastOrigin + (lastSize - tmpSize)
        }
      } else {
        curHeight = tmpSize
        if isTopOrLeft {
          curY = lastOrigin + (lastSize - tmpSize)
        }
      }
    }
  }
  
  func gestureOnEndedAction(
    line: Line,
    value: DragGesture.Value
  ) {
    if line.isVertical {
      croppedRect.size.width = curWidth
      croppedRect.origin.x = curX
    } else {
      croppedRect.size.height = curHeight
      croppedRect.origin.y = curY
    }
  }
  
  func curSpace(_ curSize: CGFloat) -> CGFloat {
    /// (curSize(width or height) - totalLineWidth) / spaceCount
    return CGFloat((curSize - 12) / 3)
  }
  
  func currentSize(
    translation: CGFloat,
    lastSize: CGFloat,
    lastOrigin: CGFloat,
    maxSize: CGFloat,
    isTopOrLeft: Bool
  ) -> CGFloat {
    let curSize: CGFloat = lastSize + translation
    let tmpMaxSize: CGFloat = isTopOrLeft ? lastSize + lastOrigin : maxSize - lastOrigin
    
    return max(minSize, min(tmpMaxSize, curSize))
  }
}

extension GridView {
  enum Line {
    case top, bottom, left, right
    
    var isTopOrLeft: Bool {
      switch self {
      case .top:
        return true
      case .left:
        return true
      case .right:
        return false
      case .bottom:
        return false
      }
    }
    
    var isVertical: Bool {
      switch self {
      case .top:
        return false
      case .left:
        return true
      case .right:
        return true
      case .bottom:
        return false
      }
    }
  }
}
