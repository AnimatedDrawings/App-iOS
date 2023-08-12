//
//  ADAnimationDTO.swift
//  AD_Feature
//
//  Created by minii on 2023/08/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct ADAnimationDTO: Codable {
  public let name: String
  
  public init(name: String) {
    self.name = name
  }
  
  public init(adAnimation: ADAnimation) {
    self.name = adAnimation.rawValue
  }
}
