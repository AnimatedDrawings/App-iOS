//
//  FindTheCharacterResponse.swift
//  AD_Feature
//
//  Created by minii on 2023/07/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct FindTheCharacterResponse: Decodable, Equatable {
  public let isSuccess: Bool
  
  public init(isSuccess: Bool) {
    self.isSuccess = isSuccess
  }
  
  enum CodingKeys: String, CodingKey {
    case isSuccess = "is_success"
  }
}
