//
//  ADAnimationDTO.swift
//  DTO
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct ADAnimationDTO: Codable {
  public let name: String
  
  public init(name: String) {
    self.name = name
  }
}
