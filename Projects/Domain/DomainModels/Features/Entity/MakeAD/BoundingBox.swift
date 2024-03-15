//
//  BoundingBox.swift
//  DomainModel
//
//  Created by chminii on 3/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import CoreModels

public struct BoundingBox: Equatable {
  public let cgRect: CGRect
  
  public init(cgRect: CGRect) {
    self.cgRect = cgRect
  }
  
  public init(dto: BoundingBoxDTO) {
    let x: CGFloat = CGFloat(dto.left)
    let y: CGFloat = CGFloat(dto.top)
    let width: CGFloat = (dto.right - dto.left) < 0 ? 0 : CGFloat(dto.right - dto.left)
    let height: CGFloat = (dto.bottom - dto.top) < 0 ? 0 : CGFloat(dto.bottom - dto.top)
    
    self.cgRect = CGRect(x: x, y: y, width: width, height: height)
  }
}

public extension BoundingBox {
  static func mockExample2() -> Self {
    return Self(dto: BoundingBoxDTO.mockExample2())
  }
}
