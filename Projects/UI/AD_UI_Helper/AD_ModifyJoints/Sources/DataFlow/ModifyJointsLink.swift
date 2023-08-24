//
//  ModifyJointsLink.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import Combine

class ModifyJointsLink: ObservableObject {
  @Published var skeletons: [String : SkeletonInfo]
  @Published var viewSize: CGSize = .init()
  @Published var currentJoint: String? = nil
  let originSkeletons: [String : SkeletonInfo]
  
  init(jointsInfo: JointsInfo) {
    self.skeletons = jointsInfo.skeletons
    self.originSkeletons = jointsInfo.skeletons
  }
}

extension ModifyJointsLink {
  func resetSkeletons() {
    self.skeletons = self.originSkeletons
  }
}
