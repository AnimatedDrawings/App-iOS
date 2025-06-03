//
//  CompressResponse.swift
//  ImageToolsInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADResources
import UIKit

public struct CompressResponse: Equatable {
  public let data: Data
  public let image: UIImage

  public init(data: Data, image: UIImage) {
    self.data = data
    self.image = image
  }
}

extension CompressResponse {
  public static func mock() -> Self {
    let image = ADResourcesAsset.GarlicTestImages.originalImage.image
    let data = image.pngData() ?? Data()
    return Self(data: data, image: image)
  }
}
