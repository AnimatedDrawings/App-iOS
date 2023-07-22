//
//  JointsInfo.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import Foundation
import Combine
import AD_Feature

class JointsInfo: ObservableObject {
  @Published var viewSize: CGSize
  var skeletonInfo: [String : SkeletonInfo]
  
  var anyCancellable = Set<AnyCancellable>()
  
  init(viewSize: CGSize, skeletonInfo: [String : SkeletonInfo]) {
    self._viewSize = Published(initialValue: viewSize)
    self.skeletonInfo = skeletonInfo
    
    self.skeletonInfo.forEach { [weak self] _, skeleton in
      guard let `self` = self else {
        return
      }
      
      skeleton.objectWillChange.sink { [weak self] _ in
        guard let `self` = self else {
          return
        }
        
        `self`.objectWillChange.send()
      }
      .store(in: &`self`.anyCancellable)
    }
  }
}

class SkeletonInfo: ObservableObject, Identifiable {
  var name: String
  @Published var ratioPoint: CGPoint
  var parent: String?
  
  init(
    name: String,
    ratioPoint: CGPoint,
    parent: String?
  ) {
    self.name = name
    self._ratioPoint = Published(initialValue: ratioPoint)
    self.parent = parent
  }
}
