//
//  Extension+Path.swift
//  AD_Utils
//
//  Created by minii on 2023/05/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public extension Path {
  mutating func addEllipse(
    at cgPoint: CGPoint,
    size: CGSize = .init(width: 5, height: 5)
  ) {
    let cgRect = CGRect(origin: cgPoint, size: size)
    self.addEllipse(in: cgRect)
  }
}
