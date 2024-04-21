//
//  WaveShape.swift
//  ADUIKitSources
//
//  Created by chminii on 1/20/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct WaveHorizontalShape: Shape {
  var animatableData: AnimatablePair<Double, Double> {
    get {
      AnimatablePair(phase, strength)
    }
    set {
      phase = newValue.first
      strength = newValue.second
    }
  }
  
  var phase: Double
  var strength: Double
  var frequency: Double
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let width = Double(rect.width)
    let height = Double(rect.height)
    let midWidth = width / 2
    let midHeight = height / 2
    let oneOverMidWidth = 1 / midWidth
    let newStrength = max(min(Double(rect.height / 2), strength), 0)
    let newFrequency = max(min(rect.width, frequency), 0)
    let wavelength = width / newFrequency
    
    path.move(to: CGPoint(x: 0, y: midHeight))
    
    for x in stride(from: 0, through: width, by: 1) {
      let relativeX = x / wavelength
      let distanceFromMidWidth = x - midWidth
      // bring that into the range of -1 to 1
      let normalDistance = oneOverMidWidth * distanceFromMidWidth
      let parabola = -(normalDistance * normalDistance) + 1
      
      let sine = sin(relativeX + phase)
      
      let y = parabola * newStrength * sine + midHeight
      //      let y = newStrength * sine + midHeight
      path.addLine(to: CGPoint(x: x, y: y))
    }
    
    return path
  }
}

struct WaveVerticalShape: Shape {
  var animatableData: AnimatablePair<Double, Double> {
    get {
      AnimatablePair(phase, strength)
    }
    set {
      phase = newValue.first
      strength = newValue.second
    }
  }
  
  var phase: Double
  var strength: Double
  var frequency: Double
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let width = Double(rect.width)
    let height = Double(rect.height)
    let midWidth = width / 2
    let midHeight = height / 2
    let oneOverMidHeight = 1 / midHeight
    let newStrength = max(min(Double(rect.width / 2), strength), 0)
    let newFrequency = max(min(rect.height, frequency), 0)
    let waveLength = height / newFrequency
    
    path.move(to: CGPoint(x: midWidth, y: 0))
    
    for y in stride(from: 0, through: height, by: 1) {
      let relativeY = y / waveLength
      
      let distanceFromMidHeight = y - midHeight
      // bring that into the range of -1 to 1
      let normalDistance = oneOverMidHeight * distanceFromMidHeight
      let parabola = -(normalDistance * normalDistance) + 1
      
      let sine = sin(relativeY + phase)
      let x = parabola * newStrength * sine + midWidth
//      let x = newStrength * sine + midWidth
      path.addLine(to: CGPoint(x: x, y: y))
    }
    
    return path
  }
}


// MARK: - Preview

struct Preview_WaveShape: View {
  @State var phase: Double = 0
  let strength: Double = 10
  let frequency: Double = 20
  
  @State var height: Double = 0
  
  var body: some View {
    VStack {
      WaveVerticalShape(phase: phase, strength: strength, frequency: frequency)
        .stroke(lineWidth: 5)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                height = geo.size.height
              }
          }
        )
      
      Button {
        withAnimation(.linear(duration: 1)) {
          phase = 2 * .pi
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          phase = 0
        }
      } label: {
        Text("Toggle Phase")
      }
    }
  }
}

#Preview {
  Preview_WaveShape()
}
