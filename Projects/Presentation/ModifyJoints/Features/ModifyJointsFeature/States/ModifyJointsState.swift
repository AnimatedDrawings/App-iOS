//
//  ModifyJointsState.swift
//  ModifyJointsFeatures
//
//  Created by chminii on 4/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import DomainModels
import UIKit
import ADComposableArchitecture
import ADResources

public extension ModifyJointsFeature {
  @ObservableState
  struct State: Equatable {
    public let originJoints: Joints
    public let croppedImage: UIImage
    
    public init(originJoints: Joints, croppedImage: UIImage) {
      self.originJoints = originJoints
      self.croppedImage = croppedImage
    }
  }
}

public extension ModifyJointsFeature.State {
  static func mock() -> Self {
    return Self(
      originJoints: .mock(),
      croppedImage: ADResourcesAsset.TestImages.croppedImage.image
    )
  }
}
