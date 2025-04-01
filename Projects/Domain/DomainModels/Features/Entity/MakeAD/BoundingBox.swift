//
//  BoundingBox.swift
//  DomainModel
//
//  Created by chminii on 3/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import CoreModels
import Foundation

public struct BoundingBox: Equatable {
  public let cgRect: CGRect

  public init(cgRect: CGRect) {
    self.cgRect = cgRect
  }

  public init(dto: BoundingBoxDTO) {
    let x: CGFloat = CGFloat(dto.left)
    let y: CGFloat = CGFloat(dto.top)
    let width: CGFloat = max(0, CGFloat(dto.right - dto.left))
    let height: CGFloat = max(0, CGFloat(dto.bottom - dto.top))

    self.cgRect = CGRect(x: x, y: y, width: width, height: height)
  }
}

extension BoundingBox {
  public static func mock() -> Self {
    return Self(dto: BoundingBoxDTO.mock())
  }

  public static func example1() -> Self {
    return Self(dto: BoundingBoxDTO.example1())
  }
}
