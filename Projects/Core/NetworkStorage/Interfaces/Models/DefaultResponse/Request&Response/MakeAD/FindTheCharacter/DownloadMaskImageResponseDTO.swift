//
//  DownloadMaskImageResponseDTO.swift
//  CoreModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct DownloadMaskImageResponseDTO {
  public let image: Data
  
  public init(image: Data) {
    self.image = image
  }
}
