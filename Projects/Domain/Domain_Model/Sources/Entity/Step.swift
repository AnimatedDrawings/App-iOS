//
//  Step.swift
//  DTO
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public enum Step: Int {
  case None = 0
  case UploadADrawing = 1
  case FindingTheCharacter = 2
  case SeparatingCharacter = 3
  case FindingCharacterJoints = 4
}

//public extension Step {
//  static func isCorrectStep(myStep: Step, completeStep: Step) -> Bool {
//    switch (myStep.rawValue, completeStep.rawValue) {
//    case let (x, y) where y + 1 < x:
//      return false
//    default:
//      return true
//    }
//  }
//
//  static func isActiveButton(myStep: Step, completeStep: Step) -> Bool {
//    switch (myStep.rawValue, completeStep.rawValue) {
//    case let (x, y) where y < x:
//      return false
//    default:
//      return true
//    }
//  }
//}

