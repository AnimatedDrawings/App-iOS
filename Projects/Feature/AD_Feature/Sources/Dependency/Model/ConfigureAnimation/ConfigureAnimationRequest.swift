//
//  ConfigureAnimationRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct ConfigureAnimationRequest: Encodable {
  public let ad_id: String
  public let name: String
  
  public init(ad_id: String, name: String) {
    self.ad_id = ad_id
    self.name = name
  }
}
