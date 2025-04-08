//
//  DownloadAnimationResponse.swift
//  NetworkProviderInterfaces
//
//  Created by chminii on 4/6/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct DownloadAnimationResponse: Equatable {
  public let animation: Data

  public init(animation: Data) {
    self.animation = animation
  }
}

public extension DownloadAnimationResponse {
  static func mock() -> Self {
    let data: Data = ADResourcesAsset.GarlicTestImages.maskedImage.image.pngData()!
    return .init(animation: data)
  }
  
  static func example1Dab() -> Self {
    let data: Data = ADResourcesAsset.Example1TestImages.e1Dab.data.data
    return .init(animation: data)
  }
}
