//
//  Extension+CGSize.swift
//  ImageToolsTestings
//
//  Created by chminii on 3/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public extension CGSize {
  func trunc() -> Self {
    Self(width: Darwin.trunc(self.width), height: Darwin.trunc(self.height))
  }
}
