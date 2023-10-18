//
//  UploadADrawingFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI
import NetworkProvider
import SharedProvider
import ADUIKit
import DomainModel

public struct UploadADrawingFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
  }
}

public extension UploadADrawingFeature {
  struct State: Equatable {
    @BindingState public var checkState1: Bool
    @BindingState public var checkState2: Bool
    @BindingState public var checkState3: Bool
    
    @BindingState public var isEnableUploadButton: Bool
    public var isShowLoadingView: Bool
    
    var isSuccessUploading: Bool
    
    @PresentationState public var alertShared: AlertState<AlertShared>?
    
    public init(
      checkState1: Bool = false,
      checkState2: Bool = false,
      checkState3: Bool = false,
      isEnableUploadButton: Bool = false,
      isShowLoadingView: Bool = false,
      isSuccessUploading: Bool = false,
      alertShared: AlertState<AlertShared>? = nil
    ) {
      self.checkState1 = checkState1
      self.checkState2 = checkState2
      self.checkState3 = checkState3
      self.isEnableUploadButton = isEnableUploadButton
      self.isShowLoadingView = isShowLoadingView
      self.isSuccessUploading = isSuccessUploading
      self.alertShared = alertShared
    }
  }
}

public extension UploadADrawingFeature {
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkList1
    case checkList2
    case checkList3
    case setIsShowLoadingView(Bool)
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<UploadDrawingResult>)
    case uploadDrawingNextAction
    
    case showAlertShared(AlertState<AlertShared>)
    case alertShared(PresentationAction<AlertShared>)
    
    case initState
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
        
        return .run { send in
          await makeAD.originalImage.set(tmpOriginalImage)
          await send(.setIsShowLoadingView(true))
          await send(
            .uploadDrawingResponse(
              TaskResult {
                try await makeADProvider.uploadDrawing(compressedData)
              }
            )
          )
          await send(.setIsShowLoadingView(false))
          await send(.uploadDrawingNextAction)
        }
        
      case .uploadDrawingResponse(.success(let result)):
        state.isSuccessUploading = true
        return .run { _ in
          await makeAD.ad_id.set(result.ad_id)
          await makeAD.boundingBox.set(result.boundingBox)
        }
        
      case .uploadDrawingResponse(.failure(let error)):
        print(error)
        state.isSuccessUploading = false
//        let adMoyaError = error as? ADMoyaError ?? .connection
        return .send(.showAlertShared(Self.initAlertNetworkError()))
        
      case .uploadDrawingNextAction:
        if state.isSuccessUploading {
          state.isSuccessUploading = false
          return .run { _ in
            await stepBar.currentStep.set(.FindingTheCharacter)
            await stepBar.isShowStepStatusBar.set(true)
            await stepBar.completeStep.set(.UploadADrawing)
          }
        }
        return .none
        
      case .alertShared:
        return .none
      case .showAlertShared(let alertState):
        state.alertShared = alertState
        return .none
        
      case .initState:
        state = State()
        return .none
      }
    }
  }
}

public extension UploadADrawingFeature {
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

extension UploadADrawingFeature {
  func activeUploadButton(state: inout UploadADrawingFeature.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 {
      state.isEnableUploadButton = true
    } else {
      state.isEnableUploadButton = false
    }
  }
}
