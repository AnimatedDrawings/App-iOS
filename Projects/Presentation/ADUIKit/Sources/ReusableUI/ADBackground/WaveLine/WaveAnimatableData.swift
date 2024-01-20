//
//  WaveAnimatableData.swift
//  ADUIKit
//
//  Created by chminii on 1/20/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct WaveAnimatableData: VectorArithmetic {
  static func - (lhs: WaveAnimatableData, rhs: WaveAnimatableData) -> WaveAnimatableData {
    return .init(
      phase: lhs.phase - rhs.phase,
      strength: lhs.strength - rhs.strength,
      frequency: lhs.frequency - rhs.frequency
    )
  }
  
  static func + (lhs: WaveAnimatableData, rhs: WaveAnimatableData) -> WaveAnimatableData {
    return .init(
      phase: lhs.phase + rhs.phase,
      strength: lhs.strength + rhs.strength,
      frequency: lhs.frequency + rhs.frequency
    )
  }
  
  var phase: Double
  var strength: Double
  var frequency: Double
  
  mutating func scale(by rhs: Double) {
    phase.scale(by: rhs)
    strength.scale(by: rhs)
    frequency.scale(by: rhs)
  }
  
  var magnitudeSquared: Double {
    return 1
  }
  
  static var zero: WaveAnimatableData {
    return .init(
      phase: .zero,
      strength: .zero,
      frequency: .zero
    )
  }
}
