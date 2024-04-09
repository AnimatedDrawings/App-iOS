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

public extension ModifyJointsFeature {
  @ObservableState
  struct State: Equatable {
//    public var skeletons: [String : Skeleton]
//    public var currentJoint: String?
//    public let imageWidth: CGFloat
//    public let imageHeight: CGFloat
//    public let originSkeletons: [String : Skeleton]
//    
//    public init(joints: Joints) {
//      self.skeletons = joints.skeletons
//      self.originSkeletons = joints.skeletons
//      self.imageWidth = joints.imageWidth
//      self.imageHeight = joints.imageHeight
//    }
    
    public let originSkeletons: [String : Skeleton]
    public let croppedImage: UIImage
    
    public init(
      skeletons: [String : Skeleton],
      croppedImage: UIImage
    ) {
      self.originSkeletons = skeletons
      self.croppedImage = croppedImage
    }
  }
}
