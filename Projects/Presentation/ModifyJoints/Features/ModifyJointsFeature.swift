//
//  ModifyJointsFeature.swift
//  ModifyJointsExample
//
//  Created by chminii on 1/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModel
import Foundation

public struct ModifyJointsFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

public extension ModifyJointsFeature {
  struct State: Equatable {
    public var skeletons: [String : Skeleton]
    public var currentJoint: String?
    public let imageWidth: CGFloat
    public let imageHeight: CGFloat
    public let originSkeletons: [String : Skeleton]
    
    public init(joints: Joints) {
      self.skeletons = joints.skeletons
      self.originSkeletons = joints.skeletons
      self.imageWidth = joints.imageWidth
      self.imageHeight = joints.imageHeight
    }
  }
}

public extension ModifyJointsFeature {
  enum Action: Equatable {
    case resetSkeletons
    case updateCurrentJoint(String?)
    case updateSkeleton(Skeleton)
  }
}

extension ModifyJointsFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .resetSkeletons:
        state.skeletons = state.originSkeletons
        return .none
        
      case .updateCurrentJoint(let name):
        state.currentJoint = name
        return .none
        
      case .updateSkeleton(let newSkeleton):
        state.skeletons[newSkeleton.name] = newSkeleton
        return .none
      }
    }
  }
}
