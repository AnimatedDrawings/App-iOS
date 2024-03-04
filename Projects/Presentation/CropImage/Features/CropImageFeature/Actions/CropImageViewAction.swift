//
//  CropImageViewAction.swift
//  CropImageExample
//
//  Created by chminii on 3/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

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
          let reciprocal: CGFloat = 1 / state.imageScale
          
          let cropCGSize = CGSize(
            width: state.viewBoundingBox.width * reciprocal,
            height: state.viewBoundingBox.height * reciprocal
          )
          
          let cropCGPoint = CGPoint(
            x: -state.viewBoundingBox.minX * reciprocal,
            y: -state.viewBoundingBox.minY * reciprocal
          )
          
          UIGraphicsBeginImageContext(cropCGSize)
          
          state.originalImage.draw(at: cropCGPoint)
          
          guard let croppedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return .none
          }
          let croppedBoundingBox = scale(
            boundingBox: state.boundingBox,
            reciprocal: reciprocal
          )
          return .none
          
        case .cancel:
          return .none
          
        case .reset:
          state.resetTrigger.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
  
  func scale(boundingBox: CGRect, reciprocal: CGFloat) -> CGRect {
    let x: CGFloat = boundingBox.minX * reciprocal
    let y: CGFloat = boundingBox.minY * reciprocal
    let width: CGFloat = boundingBox.width * reciprocal
    let height: CGFloat = boundingBox.height * reciprocal
    
    return CGRect(x: x, y: y, width: width, height: height)
  }
}
