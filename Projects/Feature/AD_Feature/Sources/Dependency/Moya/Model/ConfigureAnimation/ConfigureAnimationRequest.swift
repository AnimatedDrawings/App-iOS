//
//  ConfigureAnimationRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct ConfigureAnimationRequest {
  public let ad_id: String
  public let adAnimationDTO: ADAnimationDTO
  
  public init(ad_id: String, adAnimationDTO: ADAnimationDTO) {
    self.ad_id = ad_id
    self.adAnimationDTO = adAnimationDTO
  }
}
