//
//  BoundingBoxDTO.swift
//  AD_Feature
//
//  Created by minii on 2023/07/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct BoundingBoxDTO: Decodable, Equatable {
  public var top: Int
  public var bottom: Int
  public var left: Int
  public var right: Int
  
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
