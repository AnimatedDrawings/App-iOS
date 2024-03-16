//
//  SeparateCharacterResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import DomainModels

public struct SeparateCharacterResponse {
  public let joints: Joints
  
  public init(joints: Joints) {
    self.joints = joints
  }
}
