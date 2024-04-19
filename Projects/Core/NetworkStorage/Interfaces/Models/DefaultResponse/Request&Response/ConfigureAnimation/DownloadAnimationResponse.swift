//
//  DownloadAnimationResponse.swift
//  CoreModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct DownloadAnimationResponse: Equatable {
  public let animation: Data
  
  public init(animation: Data) {
    self.animation = animation
  }
}

public extension DownloadAnimationResponse {
  static func mock() -> Self {
    return Self(animation: .init())
  }
}
