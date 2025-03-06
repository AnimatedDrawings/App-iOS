//
//  FindTheCharacterAsyncAction.swift
//  FindTheCharacterFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import CropImageInterfaces
import NetworkProviderInterfaces
import FindTheCharacterInterfaces

public extension FindTheCharacterFeature {
  enum AsyncActions: Equatable {
    case findTheCharacter(CropImageResult)
    case findTheCharacterResponse(TaskResult<FindCharacterResponse>)
  }
  
  func AsyncReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .findTheCharacter(let cropImageResult):
          let croppedUIImage = cropImageResult.image
          let boundingBox = cropImageResult.boundingBox
          state.croppedUIImage = croppedUIImage
          
          return .run { send in
            guard let ad_id = await adInfo.id.get() else { return }
            await send(.inner(.setLoadingView(true)))
            await send(.async(.findTheCharacterResponse(
              TaskResult {
                try await makeADProvider.findCharacter(
                  ad_id: ad_id,
                  boundingBox: boundingBox
                )
              }
            )))
          }
          
        case .findTheCharacterResponse(.success(let response)):
          guard let croppedUIImage = state.croppedUIImage else {
            return .none
          }
          
          let result = FindTheCharacterResult(
            cropImage: croppedUIImage,
            maskImage: response.image
          )
          
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.popCropImageView))
            await send(.delegate(.moveToSeparateCharacter(result)))
          }
        case .findTheCharacterResponse(.failure(let error)):
          print(error)
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.networkErrorAlert))
          }
          
          //        case .downloadMaskImage:
          //          return .run { send in
          //            guard let ad_id = await adInfo.id.get() else { return }
          //            await send(.async(.downloadMaskImageResponse(
          //              TaskResult {
          //                try await makeADProvider.downloadMaskImage(ad_id: ad_id)
          //              }
          //            )))
          //          }
          //
          //        case .downloadMaskImageResponse(.success(let response)):
          //          guard let croppedUIImage = state.croppedUIImage else {
          //            return .none
          //          }
          //
          //          let result = FindTheCharacterResult(
          //            cropImage: croppedUIImage,
          //            maskImage: response.image
          //          )
          //
          //          return .run { send in
          //            await send(.inner(.setLoadingView(false)))
          //            await send(.inner(.popCropImageView))
          //            await send(.delegate(.moveToSeparateCharacter(result)))
          //          }
          //
          //        case .downloadMaskImageResponse(.failure(let error)):
          //          print(error)
          //          return .run { send in
          //            await send(.inner(.setLoadingView(false)))
          //            await send(.inner(.networkErrorAlert))
          //          }
          //        }
        }
      default:
        return .none
      }
    }
  }
}
