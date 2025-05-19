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

private enum CancelID { case render }

extension ConfigureAnimationFeature {
  public enum AsyncActions: Equatable {
    case saveGifInPhotos(URL)
    case startRendering(ADAnimation)
    case cancelRendering
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

        case .cancelRendering:
          return .cancel(id: CancelID.render)

        case .startRendering(let animation):
          state.configure.loadingDescription = "Make Animation ..."
          state.configure.selectedAnimation = animation

          return .merge(
            .run { send in
              guard let ad_id = await adInfo.id.get() else {
                await send(.inner(.setViewNeworkFail))
                return
              }
              await send(.inner(.setLoadingView(true)))
              await send(.async(.renderWebSocket(ad_id, animation)))
            }
            .cancellable(id: CancelID.render),

            .run { send in
              let result = await admobManager.getRewardADResult()
              if case .failure = result {
                await send(.async(.cancelRendering))
                await send(.inner(.setViewNeworkFail))
              }
            }
          )

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
              guard !Task.isCancelled else {
                webSocket.disconnect()
                return
              }

              let type = message.type
              let description = message.message
              curRederingType = type
              switch type {
              case .ping:
                print("ping : \(description)")
              case .running:
                print("running : \(description)")
                await send(.inner(.updateLoadingDescription(description)))
              case .complete:
                print("complete : \(description)")
                break
              case .fullJob:
                print("fullJob : \(description)")
                break
              case .error:
                print("error : \(description)")
                break
              }
            }

            webSocket.disconnect()
            print("CurRederingType : \(curRederingType)")
            switch curRederingType {
            case .complete:
              await send(.async(.downloadAnimation(ad_id, animation)))
            case .fullJob:
              await send(.inner(.setFullJob))
            default:
              await send(.inner(.setViewNeworkFail))
            }
          }
          .cancellable(id: CancelID.render)

        case .downloadAnimation(let ad_id, let animation):
          return .run { send in
            await send(.inner(.updateLoadingDescription("Download Animation ...")))
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
