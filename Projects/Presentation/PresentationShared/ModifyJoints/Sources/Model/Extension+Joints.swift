//
//  JointsInfo.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import Foundation
import DomainModel

extension Skeleton {
  func updatePoint(with newPoint: RatioPoint) -> Self {
    return Self(
      name: self.name,
      ratioPoint: newPoint,
      parent: self.parent
    )
  }
}
