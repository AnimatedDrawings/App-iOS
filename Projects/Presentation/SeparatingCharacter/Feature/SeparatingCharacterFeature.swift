//
//  SeparatingCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import MoyaProvider
import SwiftUI
import SharedProvider

public struct SeparatingCharacterFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADClient) var makeADClient
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public struct State: Equatable {
    public init() {}
    
    public var checkState1 = false
    public var checkState2 = false
    public var isActiveMaskingImageButton = false
    
    @BindingState public var isShowMaskingImageView = false
    var isSuccessSeparateCharacter = false
    public var isShowLoadingView = false
    
    @PresentationState public var alertShared: AlertState<AlertShared>? = nil
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case checkAction1
    case checkAction2
    case toggleMaskingImageView
    
    case setLoadingView(Bool)
    case maskNextAction(Bool)
    case separateCharacterResponse(TaskResult<SeparateCharacterReponse>)
    case onDismissMakingImageView
    
    case showAlertShared(AlertState<AlertShared>)
    case alertShared(PresentationAction<AlertShared>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
  }
}

extension SeparatingCharacterFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
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
        return .run { send in
          guard maskResult,
                let ad_id = await makeAD.ad_id.get(),
                let maskedImageData = await makeAD.maskedImage.get()?.pngData()
          else {
            return
          }
          
          let request = SeparateCharacterRequest(
            ad_id: ad_id,
            maskedImageData: maskedImageData
          )
          
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
        return .run { send in
          await makeAD.jointsDTO.set(response.jointsDTO)
          await send(.setLoadingView(false))
          await send(.toggleMaskingImageView)
        }
      
      case .separateCharacterResponse(.failure(let error)):
        print(error)
        state.isSuccessSeparateCharacter = false
        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(initAlertNetworkError()))
        }
          
      case .onDismissMakingImageView:
        if state.isSuccessSeparateCharacter == true {
          state.isSuccessSeparateCharacter = false
          return .run { _ in
            await stepBar.completeStep.set(.FindingTheCharacter)
            await stepBar.currentStep.set(.SeparatingCharacter)
            await stepBar.isShowStepStatusBar.set(true)
          }
        }
        return .none
        
      case .alertShared:
        return .none
      case .showAlertShared(let alertState):
        state.alertShared = alertState
        return .none
      }
    }
  }
}

extension SeparatingCharacterFeature {
  public enum AlertShared: Equatable {}
  
  func initAlertNetworkError() -> AlertState<AlertShared> {
    return AlertState(
      title: {
        TextState("Connection Error")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("Please check device network condition.")
      }
    )
  }
}

extension SeparatingCharacterFeature {
  func activeUploadButton(state: inout SeparatingCharacterFeature.State) {
    if state.checkState1 && state.checkState2 {
      state.isActiveMaskingImageButton = true
    } else {
      state.isActiveMaskingImageButton = false
    }
  }
}
