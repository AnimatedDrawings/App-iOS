//
//  WaveLine.swift
//  ADUIKit
//
//  Created by chminii on 1/20/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct WaveVerticalLine: View {
  let width: CGFloat
  @Binding var waveTrigger: Bool
  
  private let duration: Double = 1
  @State var phase: Double = 0
  @State var strength: Double = 3
  @State var frequency: Double = 10
  
  @State var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var animationSet = true
  
  var body: some View {
    WaveVerticalShape(phase: phase, strength: strength, frequency: frequency)
      .stroke(lineWidth: 5)
      .onReceive(timer) { _ in
        if animationSet {
          withAnimation(
            Animation.linear(duration: duration)
          ) {
            phase = .pi * 4
            strength = 10
            frequency = 20
          }
        } else {
          withAnimation(
            Animation.linear(duration: duration)
          ) {
            phase = .pi * 8
            strength = 3
            frequency = 10
          }
        }
        phase = 0
        animationSet.toggle()
      }
      .onChange(of: waveTrigger) { _ in
        let cancellable = timer.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration * 4)) {
          cancellable.cancel()
          timer = Timer.publish(every: 1, on: .main, in: .common)
        }
      }
  }
}

struct WaveHorizontalLine: View {
  let height: CGFloat
  @Binding var waveTrigger: Bool
  
  private let duration: Double = 1
  @State var phase: Double = 0
  @State var strength: Double = 3
  @State var frequency: Double = 10
  
  @State var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var animationSet = true
  
  var body: some View {
    WaveHorizontalShape(phase: phase, strength: strength, frequency: frequency)
      .stroke(lineWidth: 5)
      .onReceive(timer) { _ in
        if animationSet {
          withAnimation(
            Animation.linear(duration: duration)
          ) {
            phase = .pi * 4
            strength = 5
            frequency = 20
          }
        } else {
          withAnimation(
            Animation.linear(duration: duration)
          ) {
            phase = .pi * 8
            strength = 3
            frequency = 10
          }
        }
        phase = 0
        animationSet.toggle()
      }
      .onChange(of: waveTrigger) { _ in
        let cancellable = timer.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration * 4)) {
          cancellable.cancel()
          timer = Timer.publish(every: 1, on: .main, in: .common)
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
  
  var body: some View {
    VStack {
//      WaveHorizontalLine(height: size, waveTrigger: $waveTrigger)
      WaveVerticalLine(width: size, waveTrigger: $waveTrigger)
      
      Button {
        waveTrigger.toggle()
      } label: {
        Text("Wave")
      }
      
      Spacer().frame(height: 100)
    }
  }
}
