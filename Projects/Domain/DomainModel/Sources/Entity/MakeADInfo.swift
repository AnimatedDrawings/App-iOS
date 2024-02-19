//
//  MakeADInfo.swift
//  DomainModel
//
//  Created by chminii on 2/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

public struct MakeADInfo: Equatable {
  public var originalImage: UIImage?
  public var boundingBox: CGRect?
  public var initMaskImage: UIImage? // 제거
  public var croppedImage: UIImage?
  public var maskedImage: UIImage?
  public var joints: Joints?
  
  public init(originalImage: UIImage? = nil, boundingBox: CGRect? = nil, initMaskImage: UIImage? = nil, croppedImage: UIImage? = nil, maskedImage: UIImage? = nil, joints: Joints? = nil) {
    self.originalImage = originalImage
    self.boundingBox = boundingBox
    self.initMaskImage = initMaskImage
    self.croppedImage = croppedImage
    self.maskedImage = maskedImage
    self.joints = joints
  }
}
