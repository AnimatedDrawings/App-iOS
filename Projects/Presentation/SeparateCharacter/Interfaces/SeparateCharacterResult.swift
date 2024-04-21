//
//  SeparateCharacterResult.swift
//  SeparateCharacterInterfaces
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import DomainModels

public struct SeparateCharacterResult: Equatable {
  public let maskedImage: UIImage
  public let joints: Joints
  
  public init(maskedImage: UIImage, joints: Joints) {
    self.maskedImage = maskedImage
    self.joints = joints
  }
}
