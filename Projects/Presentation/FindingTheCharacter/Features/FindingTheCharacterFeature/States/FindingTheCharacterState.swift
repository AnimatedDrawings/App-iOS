//
//  FindingTheCharacterState.swift
//  FindingTheCharacter
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import CropImageFeatures
import DomainModel

public extension FindingTheCharacterFeature {
  @ObservableState
  struct State: Equatable {
    public var completeStep: Step
    public var checkList: Bool
    public var cropImageView: Bool
    public var loadingView: Bool
    var isSuccessUpload: Bool
    public var alert: Alert
    
    public var cropImage: CropImageFeature.State?
    
    public init(
      completeStep: Step = .None,
      checkList: Bool = false,
      cropImageView: Bool = false,
      loadingView: Bool = false,
      isSuccessUpload: Bool = false,
      alert: Alert = Alert(),
      cropImage: CropImageFeature.State? = nil
    ) {
      self.completeStep = completeStep
      self.checkList = checkList
      self.cropImageView = cropImageView
      self.loadingView = loadingView
      self.isSuccessUpload = isSuccessUpload
      self.alert = alert
      self.cropImage = cropImage
    }
  }
  
  @ObservableState
  struct Alert: Equatable {
    public var networkError: Bool
    public var noCropImage: Bool
    
    public init(
      networkError: Bool = false,
      noCropImage: Bool = false
    ) {
      self.networkError = networkError
      self.noCropImage = noCropImage
    }
  }
}
