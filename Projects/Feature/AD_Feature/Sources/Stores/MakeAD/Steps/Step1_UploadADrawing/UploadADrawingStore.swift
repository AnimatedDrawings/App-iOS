//
//  UploadADrawingStore.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils
import ComposableArchitecture

public struct UploadADrawingStore: ReducerProtocol {
  @Dependency(\.makeADClient) var makeADClient
  
  public init() {}
  public typealias State = TCABaseState<UploadADrawingStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState1 = false
    @BindingState public var checkState2 = false
    @BindingState public var checkState3 = false
    public var isEnableUploadButton = false
    @BindingState public var uploadProcess = false
    
    var tmpOriginalImage = UIImage()
    var isSuccessUploading = false
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case checkList1
    case checkList2
    case checkList3
    case setUploadProcess(Bool)
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<BoundingBoxDTO>)
    case uploadDrawingNextAction
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
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
        
      case .setUploadProcess(let flag):
        state.uploadProcess = flag
        return .none
        
      case .uploadDrawing(let imageData):
        guard let imageData = imageData,
              let originalImage = UIImage(data: imageData)
        else {
          return .none
        }
        
        state.tmpOriginalImage = originalImage
        
        let maxKB: Double = 3000
        let originalSize = imageData.getSize(.kilobyte)
        guard let compressedData: Data = originalSize < maxKB ?
                imageData :
                  originalImage.reduceFileSize(maxKB: maxKB)
        else {
          return .none
        }
        print(compressedData.getSize(.kilobyte))
        
        return .run { send in
          await send(.setUploadProcess(true))
          await send(
            .uploadDrawingResponse(
              TaskResult {
                try await makeADClient.step1UploadDrawing(compressedData)
              }
            )
          )
          await send(.setUploadProcess(false))
          await send(.uploadDrawingNextAction)
        }
        
      case .uploadDrawingResponse(.success(let boundingBox)):
        state.isSuccessUploading = true
        state.sharedState.boundingBoxDTO = boundingBox
        state.sharedState.originalImage = state.tmpOriginalImage
        return .none
        
      case .uploadDrawingResponse(.failure(let error)):
        state.isSuccessUploading = false
        print(error)
        return .none
        
      case .uploadDrawingNextAction:
        if state.isSuccessUploading {
          state.sharedState.completeStep = .FindingTheCharacter
          state.sharedState.currentStep = .FindingTheCharacter
          state.sharedState.isShowStepStatusBar = true
        }
        // else { showAlert = true }
        state.isSuccessUploading = false
        return .none
      }
    }
  }
}

extension UploadADrawingStore {
  func activeUploadButton(state: inout UploadADrawingStore.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 {
      state.isEnableUploadButton = true
    } else {
      state.isEnableUploadButton = false
    }
  }
}
