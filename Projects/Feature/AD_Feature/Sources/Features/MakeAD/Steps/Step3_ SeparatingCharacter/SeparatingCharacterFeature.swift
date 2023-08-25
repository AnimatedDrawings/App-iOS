//
//  SeparatingCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct SeparatingCharacterFeature: Reducer {
  @Dependency(\.makeADClient) var makeADClient
  
  public init() {}
  
  public typealias State = TCABaseState<SeparatingCharacterFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState1 = false
    @BindingState public var checkState2 = false
    public var maskState = false
    
    @BindingState public var isShowMaskingImageView = false
    var isSuccessSeparateCharacter = false
    public var isShowLoadingView = false
    
    @BindingState public var isShowAlert = false
    public var titleAlert = ""
    public var descriptionAlert = ""
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case bindIsShowStepStatusBar(Bool)
    case bindMaskedImage(UIImage?)
    
    case checkAction1
    case checkAction2
    case toggleMaskingImageView
    
    case setLoadingView(Bool)
    case maskNextAction(Bool)
    case separateCharacterResponse(TaskResult<SeparateCharacterReponse>)
    case onDismissMakingImageView
    
    case showAlert(ADMoyaError)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .bindIsShowStepStatusBar(let flag):
        state.sharedState.isShowStepStatusBar = flag
        return .none
        
      case .bindMaskedImage(let image):
        state.sharedState.maskedImage = image
        return .none
        
      case .checkAction1:
        state.checkState1.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkAction2:
        state.checkState2.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .toggleMaskingImageView:
        state.isShowMaskingImageView.toggle()
        return .none
        
      case .setLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case .maskNextAction(let maskResult):
        guard maskResult,
              let ad_id = state.sharedState.ad_id,
              let maskedImageData = state.sharedState.maskedImage?.pngData()
        else {
          return .none
        }
        
        let request = SeparateCharacterRequest(
          ad_id: ad_id,
          maskedImageData: maskedImageData
        )
        
        return .run { send in
          await send(.setLoadingView(true))
          await send(
            .separateCharacterResponse(
              TaskResult {
                try await makeADClient.step3SeparateCharacter(request)
              }
            )
          )
        }
        
      case .separateCharacterResponse(.success(let response)):
        state.isSuccessSeparateCharacter = true
        state.sharedState.jointsDTO = response.jointsDTO
        return .run { send in
          await send(.setLoadingView(false))
          await send(.toggleMaskingImageView)
        }
      
      case .separateCharacterResponse(.failure(let error)):
        print(error)
        let adError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlert(adError))
        }
          
      case .onDismissMakingImageView:
        if state.isSuccessSeparateCharacter == true {
          state.sharedState.completeStep = .FindingCharacterJoints
          state.sharedState.currentStep = .FindingCharacterJoints
          state.sharedState.isShowStepStatusBar = true
          state.isSuccessSeparateCharacter = false
        }
        return .none
        
      case .showAlert(let adError):
        state.titleAlert = adError.title
        state.descriptionAlert = adError.description
        state.isShowAlert.toggle()
        return .none
      }
    }
  }
  
  func activeUploadButton(state: inout SeparatingCharacterFeature.State) {
    if state.checkState1 && state.checkState2 {
      state.maskState = true
    } else {
      state.maskState = false
    }
  }
}
