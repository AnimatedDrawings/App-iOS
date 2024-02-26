//
//  UploadADrawingDelegateAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

public extension UploadADrawingFeature {
  enum DelegateAction: Equatable {
    case setOriginalImage(UIImage)
    case setBoundingBox(CGRect)
  }
  
  func DelegateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateAction):
        switch delegateAction {
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }
}
