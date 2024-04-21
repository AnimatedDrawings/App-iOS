//
//  ConfigureAnimationTrashState.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ConfigureAnimationFeature {
  @ObservableState
  struct Trash: Equatable {
    public var alert: Bool
    
    public init(
      alert: Bool = false
    ) {
      self.alert = alert
    }
  }
}
