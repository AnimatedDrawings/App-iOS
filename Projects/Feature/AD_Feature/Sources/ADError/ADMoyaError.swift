//
//  ADMoyaError.swift
//  AD_Feature
//
//  Created by minii on 2023/08/07.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public enum ADMoyaError: Error {
  case jsonMapping
  case calculateInServer
  case connection
  case imageMapping
  
  // 수정
  public var title: String {
    switch self {
    case .jsonMapping, .connection:
      return "Connection Error"
    case .calculateInServer, .imageMapping:
      return "Animating Error"
    }
  }
  
  public var description: String {
    switch self {
    case .jsonMapping, .connection:
      return "Please check device network condition."
    case .calculateInServer, .imageMapping:
      return "Cannot caculate Animated Drawings. Proceed Step Manually."
    }
  }
}
