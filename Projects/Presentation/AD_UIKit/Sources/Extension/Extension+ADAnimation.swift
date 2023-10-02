//
//  Extension+ADAnimation.swift
//  AD_UIKit
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Domain_Model
import Foundation

public extension ADAnimation {
  var gifData: Data {
    typealias myAsset = ADUIKitAsset.ADAnimation

    switch self {
    case .dab:
      return myAsset.dab.data.data
    case .zombie:
      return myAsset.zombie.data.data
    }
  }
}
