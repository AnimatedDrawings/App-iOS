//
//  UploadADrawingDelegateAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit
import DomainModel

public extension UploadADrawingFeature {
  enum DelegateActions: Equatable {
    case setOriginalImage(UIImage)
    case moveToFindingTheCharacter(CGRect)
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
