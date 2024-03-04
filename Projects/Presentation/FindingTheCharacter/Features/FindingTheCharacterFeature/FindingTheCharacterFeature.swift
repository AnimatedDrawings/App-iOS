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
import NetworkProvider
import CropImageFeatures

@Reducer
public struct FindingTheCharacterFeature {
  public init() {}

  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.cropImage, action: /Action.cropImage) {
      CropImageFeature()
    }
    MainReducer()
    ViewReducer()
    InnerReducer()
  }
}

public extension FindingTheCharacterFeature {
  enum Action: Equatable, BindableAction, ViewAction, InnerAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case inner(InnerActions)
    
    case findTheCharacter
    case findTheCharacterResponse(TaskEmptyResult)
    case onDismissCropImageView
    
    case downloadMaskImage
    case downloadMaskImageResponse(TaskResult<UIImage>)
    
    case showNetworkErrorAlert
    
    case initState
    
    case cropImage(CropImageFeature.Action)
  }
}

extension FindingTheCharacterFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .findTheCharacter:
        guard state.cropImage.croppedImage != nil else {
          return .none
        }
        let croppedCGRect = state.cropImage.croppedCGRect
        
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else { return }
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
        print(error)
        state.isSuccessUpload = false
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
        }
        
      case .downloadMaskImage:
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else { return }
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
        print(error)
        state.isSuccessUpload = false
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
        
      case .cropImage(.cancel):
        return .send(.toggleCropImageView)
        
      case .cropImage(.save):
        return .send(.findTheCharacter)
        
      default:
        return .none
      }
    }
  }
}
