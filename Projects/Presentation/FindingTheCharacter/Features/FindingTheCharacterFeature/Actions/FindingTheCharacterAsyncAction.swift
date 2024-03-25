//
//  FindingTheCharacterAsyncAction.swift
//  FindingTheCharacterFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import CropImageInterfaces
import NetworkProviderInterfaces
import FindingTheCharacterInterfaces

public extension FindingTheCharacterFeature {
  enum AsyncActions: Equatable {
    case findTheCharacter(CropImageResult)
    case findTheCharacterResponse(TaskEmptyResult)
    case downloadMaskImage
    case downloadMaskImageResponse(TaskResult<DownloadMaskImageResponse>)
  }
  
  func AsyncReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .findTheCharacter(let cropImageResult):
          let cropImage = cropImageResult.image
          let boundingBox = cropImageResult.boundingBox
          state.cropImageResult = cropImage
          
          return .run { send in
            guard let ad_id = await adInfo.id.get() else { return }
            await send(.inner(.setLoadingView(true)))
            await send(.async(.findTheCharacterResponse(
              TaskResult.empty {
                try await makeADProvider.findTheCharacter(ad_id: ad_id, boundingBox: boundingBox)
              }
            )))
          }
          
        case .findTheCharacterResponse(.success):
          return .send(.async(.downloadMaskImage))
        case .findTheCharacterResponse(.failure(let error)):
          print(error)
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.networkErrorAlert))
          }
          
        case .downloadMaskImage:
          return .run { send in
            guard let ad_id = await adInfo.id.get() else { return }
            await send(.async(.downloadMaskImageResponse(
              TaskResult {
                try await makeADProvider.downloadMaskImage(ad_id: ad_id)
              }
            )))
          }
          
        case .downloadMaskImageResponse(.success(let response)):
          let result = FindingTheCharacterResult(
            cropImage: state.cropImageResult,
            maskImage: response.image
          )
          
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.view(.toggleCropImageView))
            await send(.delegate(.moveToSeparatingCharacter(result)))
          }
          
        case .downloadMaskImageResponse(.failure(let error)):
          print(error)
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.networkErrorAlert))
          }
        }
      default:
        return .none
      }
    }
  }
}
