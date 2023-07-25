//
//  BoundingBoxDTO.swift
//  AD_Feature
//
//  Created by minii on 2023/07/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct BoundingBoxDTO: Decodable, Equatable {
  let top: Int
  let bottom: Int
  let left: Int
  let right: Int
  
  public init(top: Int, bottom: Int, left: Int, right: Int) {
    self.top = top
    self.bottom = bottom
    self.left = left
    self.right = right
  }
  
  public enum CodingKeys: String, CodingKey {
    case top
    case bottom
    case left
    case right
  }
}

extension BoundingBoxDTO {
  func toCGRect(scale: CGFloat) -> CGRect {
    let x: CGFloat = CGFloat(left) * scale
    let y: CGFloat = CGFloat(top) * scale
    let width: CGFloat = (right - left) < 0 ? 0 : CGFloat(right - left) * scale
    let height: CGFloat = (bottom - top) < 0 ? 0 : CGFloat(bottom - top) * scale
    
    return CGRect(x: x, y: y, width: width, height: height)
  }
}
