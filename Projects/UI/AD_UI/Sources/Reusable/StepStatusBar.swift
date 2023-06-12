//
//  StepStatusBar.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct StepStatusBar: View {
  var curIdx: Int
  @State var statusBarWidth: CGFloat = 0
  let statusBarSpacing: CGFloat = 4
  let activeColor: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  let inActiveColor: Color = .gray
  
  var body: some View {
    VStack(alignment: .leading) {
      Title()
      StatusBar()
    }
  }
}

extension StepStatusBar {
  @ViewBuilder
  func Title() -> some View {
    HStack(spacing: 20) {
      Text("S T E P")
      Text("\(curIdx) / 4")
    }
    .fontWeight(.semibold)
  }
}

extension StepStatusBar {
  @ViewBuilder
  func StatusBar() -> some View {
    GeometryReader { geo in
      HStack(spacing: statusBarSpacing) {
        ForEach(1...4, id: \.self) { idx in
          Capsule()
            .foregroundColor(capsuleColor(idx))
            .frame(width: capsuleWidth(idx))
            .animation(.easeOut, value: self.curIdx)
        }
      }
      .onAppear { calStatusBarWidth(proxy: geo) }
    }
    .frame(height: 8)
  }
  
  func calStatusBarWidth(proxy: GeometryProxy) {
    self.statusBarWidth = proxy.size.width - (statusBarSpacing * 3)
  }
  
  func capsuleColor(_ idx: Int) -> Color {
    return curIdx == idx ? activeColor : inActiveColor
  }
  
  func capsuleWidth(_ idx: Int) -> CGFloat {
    return curIdx == idx ? self.statusBarWidth / 2 : self.statusBarWidth / 6
  }
}

struct PreviewsStepStatusBar: View {
  @State var curIdx: Int = 1
  
  var body: some View {
    VStack(spacing: 100) {
      StepStatusBar(curIdx: curIdx)
      Button("MoveUp", action: moveUpAction)
      Button("MoveDown", action: moveDownAction)
    }
    .padding()
  }
  
  func moveUpAction() {
    var nexIdx = curIdx + 1
    if nexIdx == 5 {
      nexIdx = 1
    }
    
    self.curIdx = nexIdx
  }
  
  func moveDownAction() {
    var nexIdx = curIdx - 1
    if nexIdx == 0 {
      nexIdx = 4
    }
    
    self.curIdx = nexIdx
  }
}

struct StepStatusBar_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsStepStatusBar()
  }
}

