//
//  DownloadMaskImageResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit

public struct DownloadMaskImageResponse: Equatable {
  public let image: UIImage
  
  public init(image: UIImage) {
    self.image = image
  }
}
