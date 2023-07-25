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
    public var uploadState = false
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkList1
    case checkList2
    case checkList3
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<BoundingBoxDTO>)
    case uploadDrawingNextAction(UIImage)
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
                  originalImage.reduceFileSize(maxKB: maxKB)
        else {
          return .none
        }
        print(compressedData.getSize(.kilobyte))
        
        return .run { send in
          await send(
            .uploadDrawingResponse(
              TaskResult {
                try await makeADClient.step1UploadDrawing(compressedData)
              }
            )
          )
          await send(.uploadDrawingNextAction(originalImage))
        }
        
      case .uploadDrawingResponse(.success(let boundingBox)):
        state.sharedState.boundingBoxDTO = boundingBox
        return .none
        
      case .uploadDrawingResponse(.failure(let error)):
        print(error)
        return .none
        
      case .uploadDrawingNextAction(let originalImage):
        state.sharedState.originalImage = originalImage
        state.sharedState.completeStep = .FindingTheCharacter
        state.sharedState.currentStep = .FindingTheCharacter
        state.sharedState.isShowStepStatusBar = true
        return .none
      }
    }
  }
}

//      case .sampleTapAction(let image):
//        state.sharedState.originalImage = image
//        state.sharedState.completeStep = .FindingTheCharacter
//        state.sharedState.currentStep = .FindingTheCharacter
//        state.sharedState.isShowStepStatusBar = true
//        return .none

extension UploadADrawingStore {
  func activeUploadButton(state: inout UploadADrawingStore.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 {
      state.uploadState = true
    } else {
      state.uploadState = false
    }
  }
}


/// data size check < 3M
/// 1. resize, 그래도 크면 compress
/// 변환후 originalImage 저장
/// uploadimage

//        self.state.sharedState.originalImage = originalImage

//        state.sharedState.originalImage = originalImage
//        return .run { send in
//
//        }

//      case .uploadAction:
//        print("uploadAction")
//        return .none
//
//      case .sampleTapAction(let image):
//        state.sharedState.originalImage = image
//        state.sharedState.completeStep = .FindingTheCharacter
//        state.sharedState.currentStep = .FindingTheCharacter
//        state.sharedState.isShowStepStatusBar = true
//        return .none
//      }
