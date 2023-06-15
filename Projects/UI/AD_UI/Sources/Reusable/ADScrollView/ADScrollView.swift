//
//  ADScrollView.swift
//  AD_UI
//
//  Created by minii on 2023/06/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct ADScrollView<C: View>: View {
  let scrollID = "scrollID"
  var content: C
  
  init(@ViewBuilder content: () -> C) {
    self.content = content()
  }
  
  var body: some View {
    ScrollView {
      content
        .background(TrackingView(scrollID: scrollID))
    }
    .coordinateSpace(name: scrollID)
  }
}

extension ADScrollView {
  struct TrackingView: View {
    let scrollID: String
    let dist: CGFloat = 30
    @State var lastY: CGFloat = 0
    @EnvironmentObject var stepStatusBarEnvironment: StepStatusBarEnvironment
    
    var body: some View {
      HStack {
        VStack {
          GeometryReader { geo in
            Color.clear.preference(
              key: OffsetPreferenceKey.self,
              value: geo.frame(in: .named(scrollID)).origin
            )
          }
          .frame(width: 0, height: 0)
          .onPreferenceChange(
            OffsetPreferenceKey.self,
            perform: hideStepStatusBar
          )
          
          Spacer()
        }
        Spacer()
      }
    }
  }
}

extension ADScrollView.TrackingView {
  func hideStepStatusBar(_ currentOffset: CGPoint) {
    let curY: CGFloat = currentOffset.y
    print(curY)
    if 0 <= curY {
      stepStatusBarAppear()
      return
    }
    
    let translationY: CGFloat = curY - lastY
    if -dist <= translationY && translationY <= dist {
      return
    }
    
    if translationY < 0 {
      print("Scroll Down")
      stepStatusBarDisappear()
      return
    }
    
    if 0 < translationY {
      print("Scroll Up")
      stepStatusBarAppear()
      return
    }
  }
  
  func stepStatusBarAppear() {
    if self.stepStatusBarEnvironment.isHide != false {
      withAnimation {
        self.stepStatusBarEnvironment.isHide = false
      }
    }
  }
  
  func stepStatusBarDisappear() {
    if self.stepStatusBarEnvironment.isHide != true {
      withAnimation {
        self.stepStatusBarEnvironment.isHide = true
      }
    }
  }
}

struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
