//
//  CompressResponse.swift
//  ImageToolsInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct CompressResponse: Equatable {
  public let data: Data
  public let image: UIImage
//  public let original: UIImage
  
//  public init(data: Data, image: UIImage, original: UIImage) {
//    self.data = data
//    self.image = image
//    self.original = original
//  }
  
  public init(data: Data, image: UIImage) {
    self.data = data
    self.image = image
  }
}

public extension CompressResponse {
  static func mock() -> Self {
//    let mockImage = ADResourcesAsset.SampleDrawing.step1Example2.image
//    let mockData = mockImage.pngData() ?? Data()
    
//    return Self(data: mockData, image: mockImage, original: mockImage)
    
    let image = ADResourcesAsset.GarlicTestImages.originalImage.image
    let data = image.pngData() ?? Data()
    return Self(data: data, image: image)
  }
}
