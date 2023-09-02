//
//  ADAnimation.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import AD_Utils

public enum ADAnimation: String, CaseIterable {
  case dab
  case zombie
}

public extension ADAnimation {
  var gifData: Data {
    typealias myAsset = ADUtilsAsset.ADAnimation
    
    switch self {
    case .dab:
      return myAsset.dab.data.data
    case .zombie:
      return myAsset.zombie.data.data
    }
  }
}
