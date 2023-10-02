//
//  UploadADrawingFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import MoyaProvider
import SwiftUI
import SharedProvider
import AD_UIKit

public struct UploadADrawingFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADClient) var makeADClient
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public struct State: Equatable {
    public init() {}
    
    public var checkState1 = false
    public var checkState2 = false
    public var checkState3 = false
    
    public var isEnableUploadButton = false
    public var isShowLoadingView = false
    
    var isSuccessUploading = false
    
    @PresentationState public var alertShared: AlertState<AlertShared>? = nil
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkList1
    case checkList2
    case checkList3
    case setIsShowLoadingView(Bool)
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<UploadADrawingResposne>)
    case uploadDrawingNextAction
    
    case showAlertShared(AlertState<AlertShared>)
    case alertShared(PresentationAction<AlertShared>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
  }
}

extension UploadADrawingFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkList1:
        state.checkState1.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkList2:
        state.checkState2.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkList3:
        state.checkState3.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .setIsShowLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case .uploadDrawing(let imageData):
        guard let imageData = imageData,
              let originalImage = UIImage(data: imageData)
        else {
          return .none
        }
        
        let maxKB: Double = 3000
        let originalSize = imageData.getSize(.kilobyte)
        guard let compressedData: Data = originalSize < maxKB ?
                imageData :
                  originalImage.reduceFileSize(maxKB: maxKB),
              let tmpOriginalImage = UIImage(data: compressedData)
        else {
          return .none
        }
        
        let request = UploadADrawingRequest(originalImageData: compressedData)
        
        return .run { send in
          await makeAD.originalImage.set(tmpOriginalImage)
          await send(.setIsShowLoadingView(true))
          await send(
            .uploadDrawingResponse(
              TaskResult {
                try await makeADClient.step1UploadDrawing(request)
              }
            )
          )
          await send(.setIsShowLoadingView(false))
          await send(.uploadDrawingNextAction)
        }
        
      case .uploadDrawingResponse(.success(let response)):
        state.isSuccessUploading = true
        return .run { _ in
          await makeAD.ad_id.set(response.ad_id)
          await makeAD.boundingBoxDTO.set(response.boundingBoxDTO)
        }
        
      case .uploadDrawingResponse(.failure(let error)):
        state.isSuccessUploading = false
        let adMoyaError = error as? ADMoyaError ?? .connection
        return .send(.showAlertShared(initAlertNetworkError()))
        
      case .uploadDrawingNextAction:
        if state.isSuccessUploading {
          state.isSuccessUploading = false
          return .run { _ in
            await stepBar.completeStep.set(.UploadADrawing)
            await stepBar.currentStep.set(.FindingTheCharacter)
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

extension UploadADrawingFeature {
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

extension UploadADrawingFeature {
  func activeUploadButton(state: inout UploadADrawingFeature.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 {
      state.isEnableUploadButton = true
    } else {
      state.isEnableUploadButton = false
    }
  }
}
