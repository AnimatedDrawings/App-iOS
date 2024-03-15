//
//  DownloadAnimationResponse.swift
//  CoreModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct DownloadAnimationResponse {
  public let animation: Data
  
  public init(animation: Data) {
    self.animation = animation
  }
}
