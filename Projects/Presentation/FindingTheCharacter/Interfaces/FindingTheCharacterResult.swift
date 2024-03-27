//
//  FindingTheCharacterResult.swift
//  FindingTheCharacterInterfaces
//
//  Created by chminii on 3/25/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit

public struct FindingTheCharacterResult: Equatable {
  public let cropImage: UIImage
  public let maskImage: UIImage
  
  public init(cropImage: UIImage, maskImage: UIImage) {
    self.cropImage = cropImage
    self.maskImage = maskImage
  }
}

public extension FindingTheCharacterResult {
  static func mock() -> Self {
    return Self(cropImage: UIImage(), maskImage: UIImage())
  }
}
