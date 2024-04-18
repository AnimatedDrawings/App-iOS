//
//  ConfigureAnimationAsyncAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
//import Foundation
import Photos

public extension ConfigureAnimationFeature {
  enum AsyncActions: Equatable {
    case saveGifInPhotos(URL)
  }
  
  func AsyncReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .saveGifInPhotos(let fileURL):
          return .run(
            operation: { send in
              try await PHPhotoLibrary.shared().performChanges {
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, fileURL: fileURL, options: nil)
              }
              await send(.inner(.alertSaveGifResult(true)))
            },
            catch: { error, send in
              print(error)
              await send(.inner(.alertSaveGifResult(false)))
            }
          )
        }
        
      default:
        return .none
      }
    }
  }
}
