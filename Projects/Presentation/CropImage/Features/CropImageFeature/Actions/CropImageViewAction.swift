//
//  CropImageViewAction.swift
//  CropImageExample
//
//  Created by chminii on 3/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import DomainModels
import ImageToolsInterfaces
import CropImageInterfaces

public extension CropImageFeature {
  enum ViewActions: Equatable {
    case save
    case cancel
    case reset
  }
  
  func ViewReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .save:
          let cropRequest = CropRequest(
            imageScale: state.imageScale,
            viewBoundingBox: state.viewBoundingBox,
            originalImage: state.originalImage
          )
          guard let cropResult = try? imageCropper.crop(cropRequest) else {
            return .none
          }
          
          let cropImageResult = CropImageResult(
            image: cropResult.image,
            boundingBox: BoundingBox(cgRect: cropResult.boundingBox)
          )
          
          return .send(.delegate(.cropImageResult(cropImageResult)))
          
        case .cancel:
          return .send(.delegate(.cancel))
          
        case .reset:
          state.resetTrigger.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
}
