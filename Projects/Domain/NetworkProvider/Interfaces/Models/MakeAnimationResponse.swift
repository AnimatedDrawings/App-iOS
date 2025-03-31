//
//  MakeAnimationResponse.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct MakeAnimationResponse: Equatable {
  public let animation: Data

  public init(animation: Data) {
    self.animation = animation
  }
}

public extension MakeAnimationResponse {
  static func mock() -> Self {
    let data: Data = ADResourcesAsset.GarlicTestImages.maskedImage.image.pngData()!
    return .init(animation: data)
  }
}
