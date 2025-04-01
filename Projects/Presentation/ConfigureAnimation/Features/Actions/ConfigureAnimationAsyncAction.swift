//
//  ConfigureAnimationAsyncAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import NetworkProviderInterfaces
import Photos

extension ConfigureAnimationFeature {
  public enum AsyncActions: Equatable {
    case saveGifInPhotos(URL)
    case selectAnimation(ADAnimation)
    case selectAnimationResponse(TaskResult<MakeAnimationResponse>)
  }

  public func AsyncReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .saveGifInPhotos(let fileURL):
          return .run(
            operation: { send in
              try await localFileProvider.saveGIF(fileUrl: fileURL)
              await send(.inner(.alertSaveGifResult(true)))
            },
            catch: { error, send in
              await send(.inner(.alertSaveGifResult(false)))
            }
          )

        case .selectAnimation(let animation):
          if let animationFile = state.cache[animation]?.unsafelyUnwrapped {
            state.currentAnimation = animationFile
            state.configure.animationListView.toggle()
            return .none
          }
          state.configure.selectedAnimation = animation

          return .run { send in
            guard let ad_id = await adInfo.id.get() else {
              await send(.inner(.setViewNeworkFail))
              return
            }

            await send(.inner(.setLoadingView(true)))
            await send(
              .async(
                .selectAnimationResponse(
                  TaskResult {
                    try await configureAnimationProvider.makeAnimation(
                      ad_id: ad_id,
                      animation: animation
                    )
                  }
                )))
          }

        case .selectAnimationResponse(.success(let response)):
          guard let selectedAnimation = state.configure.selectedAnimation,
            let saveLocalFileResponse = try? localFileProvider.save(
              data: response.animation,
              fileExtension: .gif
            )
          else {
            return .send(.inner(.setViewNeworkFail))
          }

          let animationFile = ADAnimationFile(
            data: response.animation,
            url: saveLocalFileResponse.fileURL
          )
          state.currentAnimation = animationFile
          state.cache[selectedAnimation] = animationFile

          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.popAnimationListView))
          }

        case .selectAnimationResponse(.failure(let error)):
          print(error)
          return .send(.inner(.setViewNeworkFail))

        }

      default:
        return .none
      }
    }
  }
}
