//
//  BoundingBoxInfo.swift
//  AD_UI
//
//  Created by minii on 2023/07/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

class BoundingBoxInfo: ObservableObject {
  private var _imageScale: CGFloat = 0
  var imageScale: CGFloat {
    get {
      return self._imageScale
    }
    set {
      self._imageScale = newValue
      self.curRect = originBoundingBoxRect.scale(newValue)
      self.croppedRect = originBoundingBoxRect.scale(newValue)
    }
  }
  
  @Published var curRect: CGRect = .init()
  var croppedRect: CGRect = .init()
  var viewSize: CGRect = .init()
  
  let originBoundingBoxRect: CGRect
  
//  init(boundingBoxDTO: BoundingBoxDTO) {
//    self.originBoundingBoxRect = boundingBoxDTO.toCGRect()
//  }
  
  init(originCGRect: CGRect) {
    self.originBoundingBoxRect = originCGRect
  }
}

extension BoundingBoxInfo {
  func getCroppedCGRect() -> CGRect {
    return self.croppedRect.scale(1 / self.imageScale)
  }
  
//  func toBoundingBoxDTO() -> BoundingBoxDTO {
//    let originRect = self.croppedRect.scale(1 / self.imageScale)
//    let top = Int(originRect.origin.y)
//    let bottom = top + Int(originRect.height)
//    let left = Int(originRect.origin.x)
//    let right = left + Int(originRect.width)
//
//    return BoundingBoxDTO(top: top, bottom: bottom, left: left, right: right)
//  }
}

extension CGRect {
  func scale(_ imageScale: CGFloat) -> CGRect {
    let x: CGFloat = self.origin.x * imageScale
    let y: CGFloat = self.origin.y * imageScale
    let width: CGFloat = self.size.width * imageScale
    let height: CGFloat = self.size.height * imageScale
    
    return CGRect(x: x, y: y, width: width, height: height)
  }
}

//extension BoundingBoxDTO {
//  func toCGRect() -> CGRect {
//    let x: CGFloat = CGFloat(left)
//    let y: CGFloat = CGFloat(top)
//    let width: CGFloat = (right - left) < 0 ? 0 : CGFloat(right - left)
//    let height: CGFloat = (bottom - top) < 0 ? 0 : CGFloat(bottom - top)
//
//    return CGRect(x: x, y: y, width: width, height: height)
//  }
//}
