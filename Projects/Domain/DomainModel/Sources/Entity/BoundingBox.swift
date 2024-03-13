//
//  BoundingBox.swift
//  DomainModel
//
//  Created by chminii on 3/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public extension CGRect {
  static func mockExample2BoundingBox() -> Self {
    BoundingBoxDTO.mock().toCGRect()
  }
}
