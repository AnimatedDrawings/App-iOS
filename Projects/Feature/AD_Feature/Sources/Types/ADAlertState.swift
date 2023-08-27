//
//  ADAlertState.swift
//  AD_Feature
//
//  Created by minii on 2023/08/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import ComposableArchitecture

protocol ADAlertState: Equatable {
  var state: AlertState<Self> { get }
}

extension ADMoyaError {
  func alertState<S: ADAlertState>() -> AlertState<S> {
    let title: String
    let message: String
    
    switch self {
    case .jsonMapping, .connection:
      title = "Connection Error"
      message = "Please check device network condition."
    default:
      title = "Animating Error"
      message = "Cannot caculate Animated Drawings. Proceed Step Manually."
    }
    
    return AlertState(
      title: {
        TextState(title)
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("cancel")
        }
      },
      message: {
        TextState(message)
      }
    )
  }
}
