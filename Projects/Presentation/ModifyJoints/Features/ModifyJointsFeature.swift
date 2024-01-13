//
//  ModifyJointsFeature.swift
//  ModifyJointsExample
//
//  Created by chminii on 1/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel
import Foundation

public struct ModifyJointsFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

//@Published var skeletons: [String : Skeleton]
//@Published var viewSize: CGSize = .init()
//@Published var currentJoint: String? = nil
//let imageWidth: CGFloat
//let imageHeight: CGFloat
//let originSkeletons: [String : Skeleton]
//
//init(joints: Joints) {
//  self.skeletons = joints.skeletons
//  self.originSkeletons = joints.skeletons
//  self.imageWidth = joints.imageWidth
//  self.imageHeight = joints.imageHeight
//}

public extension ModifyJointsFeature {
  struct State: Equatable {
    public var skeletons: [String : Skeleton]
    public var viewSize: CGSize = .init()
    public var currentJoint: String?
    
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let originSkeletons: [String : Skeleton]
    
    public init(joints: Joints) {
      self.skeletons = joints.skeletons
      self.originSkeletons = joints.skeletons
      self.imageWidth = joints.imageWidth
      self.imageHeight = joints.imageHeight
    }
    
    public init() {
      let joints = Joints.mockData()!
      self.skeletons = joints.skeletons
      self.originSkeletons = joints.skeletons
      self.imageWidth = joints.imageWidth
      self.imageHeight = joints.imageHeight
    }
  }
}

public extension ModifyJointsFeature {
  enum Action: Equatable {
    case saveAction
    case cancelAction
    
    case resetSkeletons
  }
}

extension ModifyJointsFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .saveAction:
        return .none
        
      case .cancelAction:
        return .none
        
      case .resetSkeletons:
        return .none
      }
    }
  }
}
