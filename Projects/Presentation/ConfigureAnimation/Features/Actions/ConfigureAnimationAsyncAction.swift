//
//  ConfigureAnimationAsyncAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import Foundation
import NetworkProviderInterfaces
import Photos

extension ConfigureAnimationFeature {
  public enum AsyncActions: Equatable {
    case saveGifInPhotos(URL)
    case selectAnimation(ADAnimation)
    case renderWebSocket(String, ADAnimation)
    case downloadAnimation(String, ADAnimation)
    case downloadAnimationResponse(TaskResult<DownloadAnimationResponse>)
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
          state.configure.selectedAnimation = animation

          if let animationFile = state.cache[animation]?.unsafelyUnwrapped {
            state.currentAnimation = animationFile
            state.configure.animationListView.toggle()
            return .none
          }

          return .run { send in
            guard let ad_id = await adInfo.id.get() else {
              await send(.inner(.setViewNeworkFail))
              return
            }

            await send(.inner(.setLoadingView(true)))
            //            await send(.async(.downloadAnimation(ad_id, animation)))
            await send(.async(.renderWebSocket(ad_id, animation)))
          }

        case .renderWebSocket(let ad_id, let animation):
          return .run { send in
            guard
              let webSocket = try? await configureAnimationProvider.getWebSocketMakeAnimation(
                ad_id: ad_id,
                animation: animation
              )
            else {
              await send(.inner(.setViewNeworkFail))
              return
            }

            webSocket.connect()

            let messages = await configureAnimationProvider.messagesMakeAnimation(
              webSocket: webSocket
            )
            var curRederingType: RenderingType = .error
            for await message in messages {
              curRederingType = message.type
              switch message.type {
              case .ping:
                print("ping : \(message.message)")
              case .running:
                print("running : \(message.message)")
              case .complete:
                print("complete : \(message.message)")
                break
              case .fullJob:
                print("fullJob : \(message.message)")
                break
              case .error:
                print("error : \(message.message)")
                break
              }
            }

            webSocket.disconnect()
            print("CurRederingType : \(curRederingType)")
            switch curRederingType {
            case .complete:
              await send(.async(.downloadAnimation(ad_id, animation)))
            default:
              await send(.inner(.setViewNeworkFail))
            }
          }

        case .downloadAnimation(let ad_id, let animation):
          return .run { send in
            await send(
              .async(
                .downloadAnimationResponse(
                  TaskResult {
                    try await configureAnimationProvider.downloadAnimation(
                      ad_id: ad_id,
                      animation: animation
                    )
                  }
                )))
          }

        case .downloadAnimationResponse(.success(let response)):
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

        case .downloadAnimationResponse(.failure(let error)):
          print(error)
          return .send(.inner(.setViewNeworkFail))
        }
      default:
        return .none
      }
    }
  }
}
