//
//  CropImageFeature.swift
//  CropImageFeatures
//
//  Created by chminii on 1/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

@Reducer
public struct CropImageFeature {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ViewReducer()
  }
}

public extension CropImageFeature {
  enum Action: Equatable, BindableAction, ViewAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
  }
}

extension CropImageFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case.binding:
        return .none
      default:
        return .none
      }
    }
  }
}

extension CGRect {
  func scale(_ imageScale: CGFloat) -> CGRect {
    let x: CGFloat = self.origin.x * imageScale
    let y: CGFloat = self.origin.y * imageScale
    let width: CGFloat = self.size.width * imageScale
    let height: CGFloat = self.size.height * imageScale
    
    return CGRect(x: x, y: y, width: width, height: height)
  }
}


//      case .save:
////        return .run { send in
////          guard let originalImage = await originalImage.get() else {
////            return
////          }
////          await send(.crop(originalImage))
////        }
//        return .none
//
//      case .crop(let originalImage):
////        let reciprocal: CGFloat = 1 / state.boundingBoxInfo.imageScale
////
////        let cropCGSize = CGSize(
////          width: state.boundingBoxInfo.croppedRect.size.width * reciprocal,
////          height: state.boundingBoxInfo.croppedRect.size.height * reciprocal
////        )
////
////        let cropCGPoint = CGPoint(
////          x: -state.boundingBoxInfo.croppedRect.origin.x * reciprocal,
////          y: -state.boundingBoxInfo.croppedRect.origin.y * reciprocal
////        )
////
////        UIGraphicsBeginImageContext(cropCGSize)
////
////        originalImage.draw(at: cropCGPoint)
////        state.croppedImage = UIGraphicsGetImageFromCurrentImageContext()
////        state.croppedCGRect = state.boundingBoxInfo.croppedRect.scale(1 / state.boundingBoxInfo.imageScale)
//
//        return .none
//
//      case .cancel:
//        return .none
//
//      case .reset:
////        state.resetTrigger.toggle()
//        return .none
//
//      case .initViewSize(let viewSize):
////        state.boundingBoxInfo.viewSize = viewSize
//        return .none
//
//      case .initImageScale(let imageScale):
////        return .run { send in
////          guard let boundingBox = await boundingBox.get() else {
////            return
////          }
////          await send(.setImageScale(imageScale, boundingBox))
////        }
//        return .none
//
//      case let .setImageScale(imageScale, boundingBox):
////        state.boundingBoxInfo.imageScale = imageScale
////        let imageArea = boundingBox.scale(imageScale)
////        state.boundingBoxInfo.curRect = imageArea
////        state.boundingBoxInfo.croppedRect = imageArea
//        return .none
