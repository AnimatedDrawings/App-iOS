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
//  @Binding var croppedRect: CGRect
//  @Binding var curX: CGFloat
//  @Binding var curY: CGFloat
//  @Binding var curWidth: CGFloat
//  @Binding var curHeight: CGFloat
//  let maxWidth: CGFloat
//  let maxHeight: CGFloat
  
  let strokeColor: Color = ADUIKitResourcesAsset.Color.blue3.swiftUIColor
  let lineWidth: CGFloat = 3
  
  
//  @MainActor
//  init(cropImageViewStore: ViewStoreOf<CropImageFeature>) {
//    self._croppedRect = cropImageViewStore.$boundingBoxInfo.croppedRect
//    self._curX = cropImageViewStore.$boundingBoxInfo.curRect.origin.x
//    self._curY = cropImageViewStore.$boundingBoxInfo.curRect.origin.y
//    self._curWidth = cropImageViewStore.$boundingBoxInfo.curRect.size.width
//    self._curHeight = cropImageViewStore.$boundingBoxInfo.curRect.size.height
//    self.maxWidth = cropImageViewStore.boundingBoxInfo.viewSize.width
//    self.maxHeight = cropImageViewStore.boundingBoxInfo.viewSize.height
//  }
  
  @State var curPoint: CGPoint = .init()
  @State var curSize: CGSize = .init()
  let maxSize: CGSize
  
  var body: some View {
    ZStack {
      CropStroke(
        curPoint: $curPoint,
        curSize: $curSize,
        strokeColor: strokeColor,
        lineWidth: lineWidth
      )
//      CropCircles()
    }
    .contentShape(Rectangle())
    .gesture(DragGridGesture())
  }
}

extension GridView {
  func DragGridGesture() -> some Gesture {
    return DragGesture()
      .onChanged { value in
//        let curOriginX: CGFloat = croppedRect.origin.x + value.translation.width
//        let curOriginY: CGFloat = croppedRect.origin.y + value.translation.height
        let tmpX: CGFloat = curPoint.x + value.translation.width
        let tmpY: CGFloat = curPoint.y + value.translation.height
//        let tmpX: CGFloat = currentOrigin(
//          curOrigin: curX,
//          maxSize: maxWidth,
//          lastSize: croppedRect.size.width
//        )
//        let tmpY: CGFloat = currentOrigin(
//          curOrigin: curY,
//          maxSize: maxHeight,
//          lastSize: croppedRect.size.height
//        )
        
        let tmpPoint: CGPoint = CGPoint(x: tmpX, y: tmpY)
        let nexPoint: CGPoint = calNexPoint(curPoint: tmpPoint)
        if curPoint != nexPoint {
          curPoint = nexPoint
        }
        
//        if tmpX != curX {
//          curPoint.x = tmpX
//        }
//        if tmpY != curY {
//          curPoint.y = tmpY
//        }
      }
//      .onEnded { value in
//        croppedRect.origin.x = curX
//        croppedRect.origin.y = curY
//      }
  }
  
  func calNexPoint(curPoint: CGPoint) -> CGPoint {
    let nexX: CGFloat = max(0, min(curPoint.x, maxSize.width - curSize.width))
    let nexY: CGFloat = max(0, min(curPoint.y, maxSize.height - curSize.height))
    return CGPoint(x: nexX, y: nexY)
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
