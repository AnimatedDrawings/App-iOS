//
//  BoundingBoxDTO.swift
//  DTO
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import UIKit

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
  static func mock() -> Self {
    let data = """
        {
          "bottom": 987,
          "left": 104,
          "right": 835,
          "top": 105
        }
""".data(using: .utf8)!
    
    let decoded = try! JSONDecoder().decode(Self.self, from: data)
    return decoded
  }
}
