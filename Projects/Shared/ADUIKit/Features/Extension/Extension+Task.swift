//
//  Extension+Task.swift
//  ADUIKit
//
//  Created by chminii on 3/10/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import Foundation

extension Task where Success == Never, Failure == Never {
  public static func sleep(seconds: Double) async throws {
    let nanoseconds = UInt64(seconds * 1_000_000_000)
    try await Task.sleep(nanoseconds: nanoseconds)
  }
}
