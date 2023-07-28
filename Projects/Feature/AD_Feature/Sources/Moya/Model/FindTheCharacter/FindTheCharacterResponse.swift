//
//  FindTheCharacterResponse.swift
//  AD_Feature
//
//  Created by minii on 2023/07/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct FindTheCharacterResponse: Decodable, Equatable {
  public let ad_id: String
  
  public init(ad_id: String) {
    self.ad_id = ad_id
  }
  
  enum CodingKeys: String, CodingKey {
    case ad_id
  }
}
