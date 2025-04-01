//
//  SeparateCharacterAsyncAction.swift
//  SeparateCharacterFeatures
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import MaskImageInterfaces
import NetworkProviderInterfaces
import SeparateCharacterInterfaces

extension SeparateCharacterFeature {
  @CasePathable
  public enum AsyncActions: Equatable {
    case separateCharacter(MaskImageResult)
    case separateCharacterResponse(TaskResult<CutoutCharacterResponse>)
  }

  public func AsyncReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .separateCharacter(let maskImageResult):
          guard let maskedImageData = maskImageResult.image.pngData() else {
            return .none
          }
          state.maskedImage = maskImageResult.image

          return .run { send in
            guard let ad_id = await adInfo.id.get() else { return }
            await send(.inner(.setLoadingView(true)))
            await send(
              .async(
                .separateCharacterResponse(
                  TaskResult {
                    try await makeADProvider.cutoutCharacter(
                      ad_id: ad_id,
                      maskedImage: maskedImageData
                    )
                  }
                )))
          }

        case .separateCharacterResponse(
          .success(
            let response
          )
        ):
          guard let maskedImage = state.maskedImage else {
            return .none
          }

          let separateChracterResult = SeparateCharacterResult(
            maskedImage: maskedImage,
            joints: response.joints
          )

          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.popMaskImageView))
            await send(.delegate(.moveToFindCharacterJoints(separateChracterResult)))
          }

        case .separateCharacterResponse(.failure(let error)):
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
