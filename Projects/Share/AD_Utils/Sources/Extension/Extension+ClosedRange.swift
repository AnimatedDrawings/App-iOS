//
//  Extension+ClosedRange.swift
//  AD_Utils
//
//  Created by minii on 2023/05/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public extension ClosedRange {
  static func safeRange<T>(start: T, end: T) -> ClosedRange<T> {
    return Swift.min(start, end)...Swift.max(start, end)
  }
}
