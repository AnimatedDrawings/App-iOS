//
//  FindCharacterJointsResponse.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct FindCharacterJointsResponse: Codable {
  public let ad_id: String
  
  public init(ad_id: String) {
    self.ad_id = ad_id
  }
}
