//
//  CompressedInfo.swift
//  DomainModel
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct CompressedInfo: Equatable {
  public let data: Data
  public let image: UIImage
  public let original: UIImage
  
  public init(data: Data, image: UIImage, original: UIImage) {
    self.data = data
    self.image = image
    self.original = original
  }
}

public extension CompressedInfo {
  static func mock() -> Self {
    let mockImage = ADResourcesAsset.SampleDrawing.step1Example2.image
    let mockData = mockImage.pngData() ?? Data()
    
    return Self(data: mockData, image: mockImage, original: mockImage)
  }
}
