//
//  BoundingBoxDTO.swift
//  AD_Feature
//
//  Created by minii on 2023/07/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct BoundingBoxDTO: Codable, Equatable {
  public let top: Int
  public let bottom: Int
  public let left: Int
  public let right: Int
  
  public init(top: Int, bottom: Int, left: Int, right: Int) {
    self.top = top
    self.bottom = bottom
    self.left = left
    self.right = right
  }
  
  public init() {
    self.top = 0
    self.bottom = 0
    self.left = 0
    self.right = 0
  }
  
  enum CodingKeys: String, CodingKey {
    case top
    case bottom
    case left
    case right
  }
}

public extension BoundingBoxDTO {
  func toCGRect() -> CGRect {
    let x: CGFloat = CGFloat(left)
    let y: CGFloat = CGFloat(top)
    let width: CGFloat = (right - left) < 0 ? 0 : CGFloat(right - left)
    let height: CGFloat = (bottom - top) < 0 ? 0 : CGFloat(bottom - top)
    
    return CGRect(x: x, y: y, width: width, height: height)
  }
}
