//
//  WaveView.swift
//  ADUIKitSources
//
//  Created by chminii on 1/20/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct WaveView: View {
  @State var isTap = false
  @State private var horizontalSize: CGFloat = 0
  @State private var horizontalCount: Int = 0
  @State private var verticalSize: CGFloat = 0
  @State private var verticalCount: Int = 0
  
  let duration: TimeInterval = 4
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  let reloadSecond = 15
  @State private var second = 0
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        ForEach(0..<horizontalCount, id: \.self) { _ in
          WaveHorizontalLine(duration: duration, waveTrigger: $isTap)
        }
      }
      
      HStack(spacing: 0) {
        ForEach(0..<verticalCount, id: \.self) { _ in
          WaveVerticalLine(duration: duration, waveTrigger: $isTap)
        }
      }
    }
    .foregroundStyle(.gray.opacity(0.3))
    .ignoresSafeArea()
    .onAppear {
      guard let fullHeight = UIScreen.current?.bounds.size.height,
            let fullWidth = UIScreen.current?.bounds.size.width
      else {
        return
      }
      
      horizontalSize = (fullHeight / 20)
      horizontalCount = horizontalSize == 0 ? 0 : Int(fullHeight / horizontalSize)
      
      verticalSize = horizontalSize
      verticalCount = verticalSize == 0 ? 0 : Int(fullWidth / verticalSize)
    }
    .onTapGesture {
      isTap.toggle()
      second = 0
    }
    .onReceive(timer) { _ in
      second += 1
      if second == reloadSecond {
        isTap.toggle()
        second = 0
      }
    }
  }
}
