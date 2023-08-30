//
//  Extension+Bool.swift
//  AD_Utils
//
//  Created by minii on 2023/08/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public extension Bool {
  mutating func isActiveButton(_ flag: Bool) {
    self = self && flag
  }
}
