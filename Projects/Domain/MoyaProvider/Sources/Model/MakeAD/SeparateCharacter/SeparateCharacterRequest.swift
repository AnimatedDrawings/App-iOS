//
//  SeparateCharacterRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/07/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct SeparateCharacterRequest {
  public let ad_id: String
  public let maskedImageData: Data
  
  public init(ad_id: String, maskedImageData: Data) {
    self.ad_id = ad_id
    self.maskedImageData = maskedImageData
  }
}
