//
//  FindingTheCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import MoyaProvider
import SwiftUI
import SharedProvider
import Domain_Model
import AD_UIKit

public struct FindingTheCharacterFeature: Reducer {
  public init() {}

  @Dependency(\.makeADClient) var makeADClient
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public struct State: Equatable {
    public init() {}
    
    @BindingState public var checkState = false
    
    @BindingState public var isShowCropImageView = false
    public var isShowLoadingView = false
    
    var tmpCroppedImage: UIImage = .init()
    var tmpBoundingBoxDTO: BoundingBoxDTO = .init()
    var isSuccessUpload = false
   
    @PresentationState public var alertShared: AlertState<AlertShared>? = nil
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case checkAction
    case toggleCropImageView
    case findTheCharacter(UIImage?, CGRect)
    case findTheCharacterResponse(TaskResult<EmptyResponse>)
    case setLoadingView(Bool)
    case onDismissCropImageView
    
    case downloadMaskImage
    case downloadMaskImageResponse(TaskResult<UIImage>)
    
    case alertShared(PresentationAction<AlertShared>)
    case showAlertShared(AlertState<AlertShared>)
    
    case initCheckList
    case isCorrectStep
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
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
          
          let boundingBoxDTO = croppedCGRect.toBoundingBoxDTO
          let findTheCharacterRequest = FindTheCharacterRequest(
            ad_id: ad_id,
            boundingBoxDTO: boundingBoxDTO
          )
          
          await makeAD.boundingBoxDTO.set(boundingBoxDTO)
          await makeAD.croppedImage.set(croppedUIImage)
          await send(.setLoadingView(true))
          await send(
            .findTheCharacterResponse(
              TaskResult {
                try await makeADClient.step2FindTheCharacter(findTheCharacterRequest)
              }
            )
          )
        }
        
      case .findTheCharacterResponse(.success):
        return .send(.downloadMaskImage)
        
      case .findTheCharacterResponse(.failure(let error)):
        print(error)
        state.isSuccessUpload = false
        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .downloadMaskImage:
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else {
            return
          }
          
          await send(
            .downloadMaskImageResponse(
              TaskResult {
                try await makeADClient.step2DownloadMaskImage(ad_id)
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
        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .onDismissCropImageView:
        if state.isSuccessUpload {
          state.isSuccessUpload = false
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
        
        
      case .initCheckList:
        state.checkState = false
        return .none
        
      case .isCorrectStep:
        return .run { send in
          let completeStep = await stepBar.completeStep.get()
          let isCorrectStep = Step.isCorrectStep(myStep: .UploadADrawing, completeStep: completeStep)
          if !isCorrectStep {
            await send(.initCheckList)
          }
        }
      }
    }
  }
}

extension FindingTheCharacterFeature {
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
