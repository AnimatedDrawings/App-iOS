//
//  WaveView.swift
//  ADUIKitSources
//
//  Created by chminii on 1/20/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitResources

struct WaveView: View {
  @State var isTap = false
  @State private var horizontalSize: CGFloat = 0
  @State private var horizontalCount: Int = 0
  @State private var verticalSize: CGFloat = 0
  @State private var verticalCount: Int = 0
  let duration: TimeInterval = 4
  let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
  
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
    .onTapGesture {
      isTap.toggle()
    }
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
    .onReceive(timer) { _ in
      isTap.toggle()
    }
  }
}


// MARK: - Preview

struct Preview_WaveView: View {
  var body: some View {
    ADUIKitResourcesAsset.Color.blue4.swiftUIColor
      .overlay {
        WaveView()
      }
      .ignoresSafeArea()
  }
}

#Preview {
  Preview_WaveView()
}
