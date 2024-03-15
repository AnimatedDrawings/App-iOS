//
//  CGRect_BoundingBoxDTO.swift
//  Domain_Model
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import NetworkStorageInterfaces
import UIKit

public extension BoundingBoxDTO {
  func toCGRect() -> CGRect {
    let x: CGFloat = CGFloat(left)
    let y: CGFloat = CGFloat(top)
    let width: CGFloat = (right - left) < 0 ? 0 : CGFloat(right - left)
    let height: CGFloat = (bottom - top) < 0 ? 0 : CGFloat(bottom - top)

    return CGRect(x: x, y: y, width: width, height: height)
  }
}

public extension CGRect {
  func toBoundingBoxDTO() -> BoundingBoxDTO {
    let top = Int(self.origin.y)
    let bottom = top + Int(self.height)
    let left = Int(self.origin.x)
    let right = left + Int(self.width)
    
    return BoundingBoxDTO(top: top, bottom: bottom, left: left, right: right)
  }
}
