//
//  UploadDrawingAsyncAction.swift
//  UploadDrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADErrors
import Foundation
import NetworkProviderInterfaces
import UploadDrawingInterfaces

extension UploadDrawingFeature {
  public enum AsyncActions: Equatable {
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<UploadDrawingResponse>)
  }

  public func AsyncReducer() -> some Reducer<State, Action> {
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

          state.originalImage = compressedInfo.image

          return .run { send in
            await send(.inner(.setLoadingView(true)))
            await send(
              .async(
                .uploadDrawingResponse(
                  TaskResult {
                    try await makeADProvider.uploadDrawing(image: compressedInfo.data)
                  }
                )
              )
            )
          }

        case .uploadDrawingResponse(.success(let response)):
          let result = UploadDrawingResult(
            originalImage: state.originalImage,
            boundingBox: response.boundingBox
          )

          return .run { send in
            await adInfo.id.set(response.ad_id)
            await send(.inner(.setLoadingView(false)))
            await send(.delegate(.moveToFindTheCharacter(result)))
          }

        case .uploadDrawingResponse(.failure(let error)):
          print(error)
          return .run { send in
            await send(.inner(.setLoadingView(false)))
          
            if let error = error as? NetworkStorageError {
              switch error {
              case .server(statusCode: 501):
                await send(.inner(.showFindCharacterErrorAlert))
                return
              case .server(statusCode: 503):
                await send(.inner(.showWorkLoadHighErrorAlert))
                return
              default:
                break
              }
            }
            await send(.inner(.showNetworkErrorAlert))
          }
        }

      default:
        return .none
      }
    }
  }
}
