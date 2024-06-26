//
//  DownloadMaskImageResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct DownloadMaskImageResponse: Equatable {
  public let image: UIImage
  
  public init(image: UIImage) {
    self.image = image
  }
}

public extension DownloadMaskImageResponse {
  static func mock() -> Self {
    let image: UIImage = ADResourcesAsset.TestImages.maskedImage.image
    return .init(image: image)
  }
}
