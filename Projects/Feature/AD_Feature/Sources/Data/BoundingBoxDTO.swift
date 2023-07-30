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
  
  enum CodingKeys: String, CodingKey {
    case top
    case bottom
    case left
    case right
  }
}

public extension BoundingBoxDTO {
  static func mock() -> BoundingBoxDTO {
    return BoundingBoxDTO(top: 0, bottom: 0, left: 0, right: 0)
  }
  
  static func garlicMock() -> BoundingBoxDTO {
    return BoundingBoxDTO(top: 105, bottom: 987, left: 104, right: 835)
  }
}
