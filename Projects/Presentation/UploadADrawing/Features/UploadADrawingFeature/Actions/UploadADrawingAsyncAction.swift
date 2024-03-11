//
//  UploadADrawingAsyncAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import DomainModel
import NetworkStorage

public extension UploadADrawingFeature {
  enum AsyncActions: Equatable {
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<UploadDrawingResult>)
  }
  
  func AsyncReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .uploadDrawing(let imageData):
          guard let data = imageData,
                let compressedInfo = try? imageCompressor.compress(with: data)
          else {
            return .none
          }
          
          state.originalImage = compressedInfo.original
          
          return .run { send in
            await send(.inner(.setLoadingView(true)))
            await send(
              .async(
                .uploadDrawingResponse(
                  TaskResult {
                    try await makeADProvider.uploadDrawing(compressedInfo.data)
                  }
                )
              )
            )
          }
        case .uploadDrawingResponse(.success(let response)):
          let result = UploadADrawingResult(
            originalImage: state.originalImage,
            boundingBox: response.boundingBox
          )
          
          return .run { send in
            await adInfo.id.set(response.ad_id)
            await send(.inner(.setLoadingView(false)))
            await send(.delegate(.moveToFindingTheCharacter(result)))
          }
          
        case .uploadDrawingResponse(.failure(let error)):
          print(error)
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            if let error = error as? NetworkError,
               error == .ADServerError
            {
              await send(.inner(.showFindCharacterErrorAlert))
            } else {
              await send(.inner(.showNetworkErrorAlert))
            }
          }
        }
        
      default:
        return .none
      }
    }
  }
}
