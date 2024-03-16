//
//  FindingTheCharacterAsyncAction.swift
//  FindingTheCharacterFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import UIKit

public extension FindingTheCharacterFeature {
  enum AsyncActions: Equatable {
    case findTheCharacter(CropResponse)
    case findTheCharacterResponse(TaskEmptyResult)
    case downloadMaskImage
    case downloadMaskImageResponse(TaskResult<UIImage>)
  }
  
  func AsyncReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .findTheCharacter(let cropResult):
          let cropImage = cropResult.image
          let boundingBox = cropResult.boundingBox
          state.cropImageResult = cropImage
          
          return .run { send in
            guard let ad_id = await adInfo.id.get() else { return }
            await send(.inner(.setLoadingView(true)))
            await send(.async(.findTheCharacterResponse(
              TaskResult.empty {
//                try await makeADProvider.findTheCharacter(ad_id, boundingBox)
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
                try await makeADProvider.downloadMaskImage(ad_id)
              }
            )))
          }
          
        case .downloadMaskImageResponse(.success(let maskImage)):
          let result = FindingTheCharacterResult(
            cropImage: state.cropImageResult,
            maskImage: maskImage
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
