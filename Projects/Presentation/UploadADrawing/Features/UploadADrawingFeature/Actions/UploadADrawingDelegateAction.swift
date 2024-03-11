//
//  UploadADrawingDelegateAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import DomainModel

public extension UploadADrawingFeature {
  enum DelegateActions: Equatable {
    case moveToFindingTheCharacter(UploadADrawingResult)
  }
  
  func DelegateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }
}

public struct UploadADrawingResult: Equatable {
  public let originalImage: UIImage
  public let boundingBox: CGRect
  
  public init(originalImage: UIImage, boundingBox: CGRect) {
    self.originalImage = originalImage
    self.boundingBox = boundingBox
  }
}
