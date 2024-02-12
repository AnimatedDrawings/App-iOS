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
import DomainModel
import NetworkStorage
import ADUIKitSources

public struct UploadADrawingFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  @Dependency(\.adInfo) var adInfo
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
  }
}

public extension UploadADrawingFeature {
  struct State: Equatable {
    public var checkState1: Bool
    public var checkState2: Bool
    public var checkState3: Bool
    public var checkState4: Bool
    
    @BindingState public var isEnableUploadButton: Bool
    public var isShowLoadingView: Bool
    
    var isSuccessUploading: Bool
    
    @BindingState public var isShowNetworkErrorAlert: Bool
    @BindingState public var isShowFindCharacterErrorAlert: Bool
    @BindingState public var isShowImageSizeErrorAlert: Bool
    
    public init(
      checkState1: Bool = false,
      checkState2: Bool = false,
      checkState3: Bool = false,
      checkState4: Bool = false,
      isEnableUploadButton: Bool = false,
      isShowLoadingView: Bool = false,
      isSuccessUploading: Bool = false,
      isShowNetworkErrorAlert: Bool = false,
      isShowFindCharacterErrorAlert: Bool = false,
      isShowImageSizeErrorAlert: Bool = false
    ) {
      self.checkState1 = checkState1
      self.checkState2 = checkState2
      self.checkState3 = checkState3
      self.checkState4 = checkState4
      self.isEnableUploadButton = isEnableUploadButton
      self.isShowLoadingView = isShowLoadingView
      self.isSuccessUploading = isSuccessUploading
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
      self.isShowFindCharacterErrorAlert = isShowFindCharacterErrorAlert
      self.isShowImageSizeErrorAlert = isShowImageSizeErrorAlert
    }
  }
}

public extension UploadADrawingFeature {
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkList1
    case checkList2
    case checkList3
    case checkList4
    case setIsShowLoadingView(Bool)
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<UploadDrawingResult>)
    case uploadDrawingNextAction
    
    case showNetworkErrorAlert
    case showFindCharacterErrorAlert
    case showImageSizeErrorAlert
    
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
        
      case .checkList4:
        state.checkState4.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .setIsShowLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case .uploadDrawing(let imageData):
        guard let imageData = imageData,
              let originalImage = UIImage(data: imageData)
        else {
          return .send(.showImageSizeErrorAlert)
        }
        
        let maxKB: Double = 3000
        let originalSize = imageData.getSize(.kilobyte)
        if originalSize > 10000 {
          return .send(.showImageSizeErrorAlert)
        }
          
        guard let compressedData: Data = originalSize < maxKB ?
                imageData :
                  originalImage.reduceFileSize(maxKB: maxKB),
              let tmpOriginalImage = UIImage(data: compressedData)
        else {
          return .send(.showImageSizeErrorAlert)
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
          await adInfo.id.set(result.ad_id)
          await makeAD.boundingBox.set(result.boundingBox)
        }
        
      case .uploadDrawingResponse(.failure(let error)):
        state.isSuccessUploading = false
        if let error = error as? NetworkError,
           error == .ADServerError
        {
          return .send(.showFindCharacterErrorAlert)
        }
        return .send(.showNetworkErrorAlert)
        
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
        
      case .showNetworkErrorAlert:
        state.isShowNetworkErrorAlert.toggle()
        return .none
        
      case .showFindCharacterErrorAlert:
        state.isShowFindCharacterErrorAlert.toggle()
        return .none
        
      case .showImageSizeErrorAlert:
        state.isShowImageSizeErrorAlert.toggle()
        return .none
        
      case .initState:
        state = State()
        return .none
      }
    }
  }
}

extension UploadADrawingFeature {
  func activeUploadButton(state: inout UploadADrawingFeature.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 && state.checkState4 {
      state.isEnableUploadButton = true
    } else {
      state.isEnableUploadButton = false
    }
  }
}
