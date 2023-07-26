//
//  BoundingBoxInfo.swift
//  AD_UI
//
//  Created by minii on 2023/07/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature

class BoundingBoxInfo: ObservableObject {
  private var _imageScale: CGFloat = 0
  var imageScale: CGFloat {
    get {
      return self._imageScale
    }
    set {
      self._imageScale = newValue
      self.initRect = originBoundingBoxRect.scale(newValue)
    }
  }
  
  @Published var initRect: CGRect = .init()
  @Published var viewSize: CGRect = .init()
  @Published var cropRect: CGRect = .init()
  
  let originBoundingBoxRect: CGRect
  
  init(boundingBoxDTO: BoundingBoxDTO) {
    self.originBoundingBoxRect = boundingBoxDTO.toCGRect()
  }
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

extension BoundingBoxDTO {
  func toCGRect() -> CGRect {
    let x: CGFloat = CGFloat(left)
    let y: CGFloat = CGFloat(top)
    let width: CGFloat = (right - left) < 0 ? 0 : CGFloat(right - left)
    let height: CGFloat = (bottom - top) < 0 ? 0 : CGFloat(bottom - top)

    return CGRect(x: x, y: y, width: width, height: height)
  }
}
