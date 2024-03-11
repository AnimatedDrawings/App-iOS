//
//  SeparatingCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import SwiftUI
import SharedProvider
import NetworkProvider
import DomainModel
import MaskingImageFeatures

public struct SeparatingCharacterFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.maskingImage, action: /Action.maskingImage) {
      MaskingImageFeature()
    }
    MainReducer()
  }
}

public extension SeparatingCharacterFeature {
  struct State: Equatable {
    @BindingState public var checkState1: Bool
    @BindingState public var checkState2: Bool
    @BindingState public var isActiveMaskingImageButton: Bool
    
    @BindingState public var isShowMaskingImageView: Bool
    var isSuccessSeparateCharacter: Bool
    public var isShowLoadingView: Bool
    
    @BindingState public var isShowNetworkErrorAlert: Bool
    
    public var maskingImage: MaskingImageFeature.State
    
    public init(
      checkState1: Bool = false,
      checkState2: Bool = false,
      isActiveMaskingImageButton: Bool = false,
      isShowMaskingImageView: Bool = false,
      isSuccessSeparateCharacter: Bool = false,
      isShowLoadingView: Bool = false,
      isShowNetworkErrorAlert: Bool = false,
      maskingImage: MaskingImageFeature.State = .init()
    ) {
      self.checkState1 = checkState1
      self.checkState2 = checkState2
      self.isActiveMaskingImageButton = isActiveMaskingImageButton
      self.isShowMaskingImageView = isShowMaskingImageView
      self.isSuccessSeparateCharacter = isSuccessSeparateCharacter
      self.isShowLoadingView = isShowLoadingView
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
      self.maskingImage = maskingImage
    }
  }
}

public extension SeparatingCharacterFeature {
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkAction1
    case checkAction2
    case toggleMaskingImageView
    
    case setLoadingView(Bool)
    case maskNextAction
    case separateCharacterResponse(TaskResult<Joints>)
    case onDismissMakingImageView
    
    case showNetworkErrorAlert
    
    case initState
    
    case maskingImage(MaskingImageFeature.Action)
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
        
      case .maskNextAction:
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get(),
                let maskedImageData = await makeAD.maskedImage.get()?.pngData()
          else {
            return
          }
          
          await send(.setLoadingView(true))
          await send(
            .separateCharacterResponse(
              TaskResult {
                try await makeADProvider.separateCharacter(ad_id, maskedImageData)
              }
            )
          )
        }
        
      case .separateCharacterResponse(.success(let joints)):
        state.isSuccessSeparateCharacter = true
        return .run { send in
          await makeAD.joints.set(joints)
          await send(.setLoadingView(false))
          await send(.toggleMaskingImageView)
        }
        
      case .separateCharacterResponse(.failure(let error)):
        print(error)
        state.isSuccessSeparateCharacter = false
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
        }
        
      case .onDismissMakingImageView:
        if state.isSuccessSeparateCharacter == true {
          state.isSuccessSeparateCharacter = false
          return .run { _ in
            await stepBar.currentStep.set(.FindingCharacterJoints)
            await stepBar.isShowStepBar.set(true)
            await stepBar.completeStep.set(.SeparatingCharacter)
          }
        }
        return .none
        
      case .showNetworkErrorAlert:
        state.isShowNetworkErrorAlert.toggle()
        return .none
        
      case .initState:
        state = State()
        return .none
        
      case .maskingImage(.cancelAction):
        return .send(.toggleMaskingImageView)
        
      case .maskingImage(.saveAction):
        return .send(.maskNextAction)
        
      default:
        return .none
      }
    }
  }
}

public extension SeparatingCharacterFeature {
  enum AlertShared: Equatable {}
  
  static func initAlertNetworkError() -> AlertState<AlertShared> {
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
