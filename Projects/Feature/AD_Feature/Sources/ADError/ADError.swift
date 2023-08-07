//
//  ADError.swift
//  AD_Feature
//
//  Created by minii on 2023/08/07.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

enum ADError: Error {
  case jsonMapping
  case calculateInServer
  case connection
  
  var title: String {
    switch self {
    case .jsonMapping, .connection:
      return "Connection Error"
    case .calculateInServer:
      return "Animating Error"
    }
  }
  
  var description: String {
    switch self {
    case .jsonMapping, .connection:
      return "Please check device network condition."
    case .calculateInServer:
      return "Cannot caculate Animated Drawings. Proceed Step Manually."
    }
  }
}
