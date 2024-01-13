//
//  ModifyJointsLink.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import Combine
import DomainModel

class ModifyJointsLink: ObservableObject {
  @Published var skeletons: [String : Skeleton]
  @Published var viewSize: CGSize = .init()
  @Published var currentJoint: String? = nil
  let imageWidth: CGFloat
  let imageHeight: CGFloat
  let originSkeletons: [String : Skeleton]
  
  init(joints: Joints) {
    self.skeletons = joints.skeletons
    self.originSkeletons = joints.skeletons
    self.imageWidth = joints.imageWidth
    self.imageHeight = joints.imageHeight
  }
}

extension ModifyJointsLink {
  func resetSkeletons() {
    self.skeletons = self.originSkeletons
  }
}
