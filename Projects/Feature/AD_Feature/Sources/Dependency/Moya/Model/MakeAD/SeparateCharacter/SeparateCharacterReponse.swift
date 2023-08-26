//
//  SeparateCharacterReponse.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct SeparateCharacterReponse: Responsable {
  public let jointsDTO: JointsDTO
  
  public init(jointsDTO: JointsDTO) {
    self.jointsDTO = jointsDTO
  }
  
  enum CodingKeys: String, CodingKey {
    case jointsDTO = "char_cfg"
  }
}
