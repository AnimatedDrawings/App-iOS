//
//  FindingTheCharacterDelegateAction.swift
//  FindingTheCharacterFeatures
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

public extension FindingTheCharacterFeature {
  enum DelegateActions: Equatable {
    case moveToSeparatingCharacter(FindingTheCharacterResult)
  }
  
  func DelegateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
      default:
        return .none
      }
    }
  }
}

public struct FindingTheCharacterResult: Equatable {
  public let cropImage: UIImage
  public let maskImage: UIImage
  
  public init(cropImage: UIImage, maskImage: UIImage) {
    self.cropImage = cropImage
    self.maskImage = maskImage
  }
}
