//
//  GridView.swift
//  AD_UI
//
//  Created by minii on 2023/06/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADResources
import ADComposableArchitecture
import CropImageFeatures

struct GridView: View {
  let maxSize: CGSize
  @Binding var initalBoundingBox: CGRect
  let updateBoundingBox: (CGRect) -> ()
  
  @State var curRect: CGRect = .init()
  @State var lastRect: CGRect = .init()
  let strokeColor: Color = ADResourcesAsset.Color.blue3.swiftUIColor
  let lineWidth: CGFloat = 3
  
  init(
    initalBoundingBox: Binding<CGRect>,
    viewSize maxSize: CGSize,
    updateBoundingBox: @escaping (CGRect) -> ()
  ) {
    self._initalBoundingBox = initalBoundingBox
    self.maxSize = maxSize
    self.updateBoundingBox = updateBoundingBox
  }
  
  var body: some View {
    ZStack {
      CropStroke(
        curRect: $curRect,
        strokeColor: strokeColor,
        lineWidth: lineWidth
      )
      CropCircles(
        curRect: $curRect,
        lastRect: $lastRect,
        maxSize: maxSize,
        strokeColor: strokeColor,
        lineWidth: lineWidth
      )
    }
    .contentShape(Rectangle())
    .gesture(DragGridGesture())
    .onChange(of: initalBoundingBox, perform: initBoundingBox)
    .onChange(of: lastRect, perform: updateBoundingBoxAction)
  }
}

extension GridView {
  func initBoundingBox(_: CGRect) {
    self.curRect = initalBoundingBox
    self.lastRect = initalBoundingBox
  }
  
  func updateBoundingBoxAction(_: CGRect) {
    updateBoundingBox(lastRect)
  }
}

extension GridView {
  func DragGridGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        let nexX: CGFloat = lastRect.minX + value.translation.width
        let nexY: CGFloat = lastRect.minY + value.translation.height
        guard 0 < nexX && nexX < maxSize.width - lastRect.width else {
          return
        }
        guard 0 < nexY && nexY < maxSize.height - lastRect.height else {
          return
        }
        
        curRect.origin = CGPoint(x: nexX, y: nexY)
      }
      .onEnded { _ in
        lastRect = curRect
      }
  }
}
