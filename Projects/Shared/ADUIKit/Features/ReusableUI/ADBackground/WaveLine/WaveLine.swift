//
//  WaveLine.swift
//  ADUIKit
//
//  Created by chminii on 1/20/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import Combine

struct WaveVerticalLine: View {
  @Binding var waveTrigger: Bool
  
  let duration: TimeInterval
  let frequency: Double
  
  @State var phase: Double
  let minPhase: Double
  let maxPhase: Double
  
  @State var strength: Double
  let minStrength: Double
  let maxStrength: Double
  
  init(
    duration: Double,
    waveTrigger: Binding<Bool>
  ) {
    self._waveTrigger = waveTrigger
    
    self.duration = duration
    self.frequency = Double.random(in: 10...20)
    
    self.minPhase = 0
    self.maxPhase = (2 * .pi) * Double(Int.random(in: 3...7))
    self._phase = State(initialValue: 0)
    
    self.minStrength = 10
    self.maxStrength = 25
    self._strength = State(initialValue: minStrength)
  }
  
  var body: some View {
    WaveVerticalShape(phase: phase, strength: strength, frequency: frequency)
      .stroke(lineWidth: 5)
      .onChange(of: waveTrigger) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
          phase = minPhase
        }
        
        withAnimation(.linear(duration: duration / 2)) {
          strength = maxStrength
        }
        
        withAnimation(.linear(duration: duration)) {
          phase = maxPhase
        }
        
        withAnimation(.linear(duration: duration / 2)) {
          strength = minStrength
        }
      }
  }
}

struct WaveHorizontalLine: View {
  @Binding var waveTrigger: Bool
  
  let duration: Double
  let frequency: Double
  
  @State var phase: Double
  let minPhase: Double
  let maxPhase: Double
  
  @State var strength: Double
  let minStrength: Double
  let maxStrength: Double
  
  init(
    duration: Double,
    waveTrigger: Binding<Bool>
  ) {
    self.duration = duration
    self.frequency = Double.random(in: 10...20)
    
    self._waveTrigger = waveTrigger
    
    self.minPhase = 0
    self.maxPhase = (2 * .pi) * Double(Int.random(in: 3...7))
    self._phase = State(initialValue: 0)
    
    self.minStrength = 4
    self.maxStrength = 14
    self._strength = State(initialValue: minStrength)
  }
  
  var body: some View {
    WaveHorizontalShape(phase: phase, strength: strength, frequency: frequency)
      .stroke(lineWidth: 5)
      .onChange(of: waveTrigger) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
          phase = minPhase
        }
        
        withAnimation(.linear(duration: duration / 2)) {
          strength = maxStrength
        }
        
        withAnimation(.linear(duration: duration)) {
          phase = maxPhase
        }
        
        withAnimation(.linear(duration: duration / 2)) {
          strength = minStrength
        }
      }
  }
}


// MARK: - Preview

#Preview {
  Preview_WaveLine()
}

struct Preview_WaveLine: View {
  @State private var waveTrigger = true
  private let size: CGFloat = 100
  let duration: TimeInterval = 4
  
  var body: some View {
    VStack {
      ZStack {
        WaveHorizontalLine(duration: duration, waveTrigger: $waveTrigger)
        WaveVerticalLine(duration: duration, waveTrigger: $waveTrigger)
      }
      
      Button {
        waveTrigger.toggle()
      } label: {
        Text("Wave")
      }
    }
  }
}
