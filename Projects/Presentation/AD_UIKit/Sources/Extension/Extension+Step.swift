//
//  Extension+Step.swift
//  AD_UIKit
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Domain_Model

public extension Step {
  static func isCorrectStep(myStep: Step, completeStep: Step) -> Bool {
    switch (myStep.rawValue, completeStep.rawValue) {
    case let (x, y) where y + 1 < x:
      return false
    default:
      return true
    }
  }
  
  static func isActiveButton(myStep: Step, completeStep: Step) -> Bool {
    switch (myStep.rawValue, completeStep.rawValue) {
    case let (x, y) where y < x:
      return false
    default:
      return true
    }
  }
}
