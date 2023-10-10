//
//  FindCharacterJointsRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct FindCharacterJointsRequest {
  public let ad_id: String
  public let jointsDTO: JointsDTO
  
  public init(ad_id: String, jointsDTO: JointsDTO) {
    self.ad_id = ad_id
    self.jointsDTO = jointsDTO
  }
  
  enum CodingKeys: String, CodingKey {
    case ad_id
    case jointsDTO = "joints"
  }
}
