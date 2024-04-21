//
//  ConfigureAnimationShareState.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ConfigureAnimationFeature {
  @ObservableState
  struct Share: Equatable {
    public var saveResult: SaveResult
    public var alertNoAnimation: Bool
    public var sheetShare: Bool
    public var sheetShareFile: Bool
    
    public init(
      saveResult: SaveResult = .init(),
      alertNoAnimation: Bool = false,
      sheetShare: Bool = false,
      sheetShareFile: Bool = false
    ) {
      self.saveResult = saveResult
      self.alertNoAnimation = alertNoAnimation
      self.sheetShare = sheetShare
      self.sheetShareFile = sheetShareFile
    }
  }
  
  @ObservableState
  struct SaveResult: Equatable {
    public var alert: Bool
    public var isSuccess: Bool
    
    public init(
      alert: Bool = false,
      isSuccess: Bool = false
    ) {
      self.alert = alert
      self.isSuccess = isSuccess
    }
  }
}
