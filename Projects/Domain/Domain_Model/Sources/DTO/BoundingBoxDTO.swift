//
//  BoundingBoxDTO.swift
//  DTO
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

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

public extension CGRect {
  var toBoundingBoxDTO: BoundingBoxDTO {
    let top = Int(self.origin.y)
    let bottom = top + Int(self.height)
    let left = Int(self.origin.x)
    let right = left + Int(self.width)
    
    return BoundingBoxDTO(top: top, bottom: bottom, left: left, right: right)
  }
}

