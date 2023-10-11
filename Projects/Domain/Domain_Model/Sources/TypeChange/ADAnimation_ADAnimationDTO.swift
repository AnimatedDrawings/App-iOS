//
//  ADAnimation_ADAnimationDTO.swift
//  Domain_Model
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Core_Model

public extension ADAnimation {
  func toDTO() -> ADAnimationDTO {
    ADAnimationDTO(name: self.rawValue)
  }
}
