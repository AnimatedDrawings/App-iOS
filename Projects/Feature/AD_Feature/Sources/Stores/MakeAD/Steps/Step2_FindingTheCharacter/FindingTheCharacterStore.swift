//
//  FindingTheCharacterStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct FindingTheCharacterStore: ReducerProtocol {
  @Dependency(\.makeADClient) var makeADClient
  
  public init() {}
  public typealias State = TCABaseState<FindingTheCharacterStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState = false
    @BindingState public var isShowCropImageView = false
    
    public var isShowLoadingView = false
    public var descriptionLoadingView = ""
    
    var isSuccessCrop = false
    var isSuccessUpload = false
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case checkAction
    case toggleCropImageView
//    case cropNextAction(UIImage?)
    case cropAction(CropResult)
    case saveInLocalCropResult(CropResult)
    case uploadCroppedImage
    case setLoadingView(Bool, String? = nil)
    case onDismissCropImageView
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
        
      case .toggleCropImageView:
        state.isShowCropImageView.toggle()
        return .none
        
      case let .setLoadingView(flag, description):
        if flag, let description = description {
          state.descriptionLoadingView = description
        }
        if state.isShowLoadingView != flag {
          state.isShowLoadingView = flag
        }
        return .none
        
      case .cropAction(let cropResult):
        return .run { send in
          await send(.setLoadingView(true, "Cropping Image ..."))
          await send(.saveInLocalCropResult(cropResult))
          await send(.setLoadingView(true, "Upload Cropped Image ..."))
          await send(.uploadCroppedImage)
          await send(.setLoadingView(false))
        }
        
      case .saveInLocalCropResult(let cropResult):
        guard let croppedImage = cropResult.crop() else {
          return .none
        }
        state.sharedState.croppedImage = croppedImage
        state.isSuccessCrop = true
        return .none
        
      case .uploadCroppedImage:
        let isSuccessUpload = true
        state.isSuccessUpload = isSuccessUpload
        if isSuccessUpload {
          return .send(.toggleCropImageView)
        }
        return .none
        
      case .onDismissCropImageView:
        if state.isSuccessCrop && state.isSuccessUpload {
          state.sharedState.completeStep = .SeparatingCharacter
          state.sharedState.currentStep = .SeparatingCharacter
          state.sharedState.isShowStepStatusBar = true
          state.isSuccessCrop = false
          state.isSuccessUpload = false
        }
        return .none
      }
    }
  }
}

public struct CropResult: Equatable {
  public static func == (lhs: CropResult, rhs: CropResult) -> Bool {
    lhs.id == rhs.id
  }
  
  public init(crop: @escaping () -> UIImage?) {
    self.crop = crop
  }
  
  public let id = UUID()
  public let crop: () -> UIImage?
}
