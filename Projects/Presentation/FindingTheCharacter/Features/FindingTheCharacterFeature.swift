//
//  FindingTheCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI
import SharedProvider
import DomainModel
import ADUIKit
import NetworkProvider

public struct FindingTheCharacterFeature: Reducer {
  public init() {}

  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
  }
}

public extension FindingTheCharacterFeature {
  struct State: Equatable {
    @BindingState public var checkState: Bool

    @BindingState public var isShowCropImageView: Bool
    public var isShowLoadingView: Bool
    
    var isSuccessUpload: Bool
   
    @BindingState public var isShowNetworkErrorAlert: Bool
    
    public init(
      checkState: Bool = false,
      isShowCropImageView: Bool = false,
      isShowLoadingView: Bool = false,
      isSuccessUpload: Bool = false,
      isShowNetworkErrorAlert: Bool = false
    ) {
      self.checkState = checkState
      self.isShowCropImageView = isShowCropImageView
      self.isShowLoadingView = isShowLoadingView
      self.isSuccessUpload = isSuccessUpload
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
    }
  }
}

public extension FindingTheCharacterFeature {
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkAction
    case toggleCropImageView
    case findTheCharacter(UIImage?, CGRect)
    case findTheCharacterResponse(TaskEmptyResult)
    case setLoadingView(Bool)
    case onDismissCropImageView
    
    case downloadMaskImage
    case downloadMaskImageResponse(TaskResult<UIImage>)
    
    case showNetworkErrorAlert
    
    case initState
  }
}

extension FindingTheCharacterFeature {
  func MainReducer() -> some Reducer<State, Action> {
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
        
      case .setLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case let .findTheCharacter(croppedUIImage, croppedCGRect):
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get(),
                let croppedUIImage = croppedUIImage
          else {
            return
          }
          
          await makeAD.boundingBox.set(croppedCGRect)
          await makeAD.croppedImage.set(croppedUIImage)
          await send(.setLoadingView(true))
          await send(
            .findTheCharacterResponse(
              TaskResult.empty {
                try await makeADProvider.findTheCharacter(ad_id, croppedCGRect)
              }
            )
          )
        }
        
      case .findTheCharacterResponse(.success):
        return .send(.downloadMaskImage)
        
      case .findTheCharacterResponse(.failure(let error)):
        state.isSuccessUpload = false
//        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
        }
        
      case .downloadMaskImage:
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else {
            return
          }
          
          await send(
            .downloadMaskImageResponse(
              TaskResult {
                try await makeADProvider.downloadMaskImage(ad_id)
              }
            )
          )
        }
        
      case .downloadMaskImageResponse(.success(let maskImage)):
        state.isSuccessUpload = true
        return .run { send in
          await makeAD.initMaskImage.set(maskImage)
          await send(.setLoadingView(false))
          await send(.toggleCropImageView)
        }
        
      case .downloadMaskImageResponse(.failure(let error)):
        state.isSuccessUpload = false
//        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
        }
        
      case .onDismissCropImageView:
        if state.isSuccessUpload {
          state.isSuccessUpload = false
          return .run { _ in
            await stepBar.currentStep.set(.SeparatingCharacter)
            await stepBar.isShowStepStatusBar.set(true)
            await stepBar.completeStep.set(.FindingTheCharacter)
          }
        }
        return .none
        
      case .showNetworkErrorAlert:
        state.isShowNetworkErrorAlert.toggle()
        return .none
        
      case .initState:
        state = State()
        return .none
      }
    }
  }
}
