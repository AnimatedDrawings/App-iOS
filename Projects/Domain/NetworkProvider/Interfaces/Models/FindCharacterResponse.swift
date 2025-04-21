//
//  FindCharacterResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADResources
import UIKit

public struct FindCharacterResponse: Equatable {
  public let image: UIImage

  public init(image: UIImage) {
    self.image = image
  }
}

extension FindCharacterResponse {
  public static func mock() -> Self {
    let image: UIImage = ADResourcesAsset.GarlicTestImages.maskedImage.image
    return .init(image: image)
  }

  public static func example1() -> Self {
    let image: UIImage = ADResourcesAsset.Example1TestImages.e1CutoutCharacterImage.image
    return .init(image: image)
  }
}
