//
//  DownloadAnimationResponseDTO.swift
//  NetworkRepository
//
//  Created by chminii on 4/8/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import Foundation

public struct DownloadAnimationResponseDTO: Decodable {
  public let animation: Data

  public init(animation: Data) {
    self.animation = animation
  }
}
