//
//  ConfigureAnimationState.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import Foundation

public extension ConfigureAnimationFeature {
  typealias Cache = [ADAnimation : ADAnimationFile?]
  
  @ObservableState
  struct State: Equatable {
    public var currentAnimation: ADAnimationFile?
    public var cache: [ADAnimation : ADAnimationFile?]
    public var trash: ConfigureAnimationFeature.Trash
    public var share: ConfigureAnimationFeature.Share
    public var configure: ConfigureAnimationFeature.Configure
    
    public init(
      currentAnimation: ADAnimationFile? = nil,
      cache: Cache = ConfigureAnimationFeature.initCache(),
      trash: ConfigureAnimationFeature.Trash = .init(),
      share: ConfigureAnimationFeature.Share = .init(),
      configure: ConfigureAnimationFeature.Configure = .init()
    ) {
      self.currentAnimation = currentAnimation
      self.cache = cache
      self.trash = trash
      self.share = share
      self.configure = configure
    }
  }
}

public extension ConfigureAnimationFeature {
  static func initCache() -> Cache {
    return ADAnimation.allCases
      .reduce(into: Cache()) { dict, key in
        dict[key] = nil
      }
  }
}

public extension ConfigureAnimationFeature {
  @ObservableState
  struct ADAnimationFile: Equatable {
    public var data: Data
    public var url: URL
    
    public init(
      data: Data = .init(),
      url: URL = .init(filePath: "")
    ) {
      self.data = data
      self.url = url
    }
  }
}
