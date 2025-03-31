//
//  CutoutCharacterResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import DomainModels

public struct CutoutCharacterResponse: Equatable {
  public let joints: Joints

  public init(joints: Joints) {
    self.joints = joints
  }
}

extension CutoutCharacterResponse {
  public static func mock() -> Self {
    .init(joints: Joints.mock())
  }

  public static func example1() -> Self {
    .init(joints: Joints.example1())
  }
}
